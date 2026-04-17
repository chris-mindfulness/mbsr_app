/**
 * Appwrite Function: tracking_retention_cleanup
 *
 * Loescht Aggregatdaten aelter als N Monate (default: 12).
 *
 * ENV:
 * - APPWRITE_ENDPOINT
 * - APPWRITE_PROJECT_ID
 * - APPWRITE_API_KEY
 * - APPWRITE_DATABASE_ID (default: mbsr_database)
 * - APPWRITE_AUDIO_DAILY_TABLE_ID (default: audio_daily_aggregate)
 * - APPWRITE_SLOT_DAILY_TABLE_ID (default: slot_daily_aggregate)
 * - APPWRITE_WEEKLY_DISTRIBUTION_TABLE_ID (default: weekly_distribution_aggregate)
 * - APP_TRACKING_RETENTION_MONTHS (default: 12)
 * - APP_TRACKING_RETENTION_DRY_RUN (default: false)
 */

const DEFAULT_DATABASE_ID = "mbsr_database";
const DEFAULT_AUDIO_TABLE_ID = "audio_daily_aggregate";
const DEFAULT_SLOT_TABLE_ID = "slot_daily_aggregate";
const DEFAULT_WEEKLY_TABLE_ID = "weekly_distribution_aggregate";
const DEFAULT_RETENTION_MONTHS = 12;

module.exports = async ({ res, log, error }) => {
  try {
    const env = readEnv();
    const cutoffDate = buildCutoffDate(env.retentionMonths);
    const cutoffDateKey = formatDateKey(cutoffDate);
    const cutoffWeekKey = formatWeekKey(cutoffDate);

    const audioResult = await cleanupByDateKey({
      env,
      tableId: env.audioDailyTableId,
      cutoffDateKey,
      dryRun: env.dryRun,
      log,
    });
    const slotResult = await cleanupByDateKey({
      env,
      tableId: env.slotDailyTableId,
      cutoffDateKey,
      dryRun: env.dryRun,
      log,
    });
    const weeklyResult = await cleanupByWeekKey({
      env,
      tableId: env.weeklyDistributionTableId,
      cutoffWeekKey,
      dryRun: env.dryRun,
      log,
    });

    return res.json(
      {
        ok: true,
        dry_run: env.dryRun,
        retention_months: env.retentionMonths,
        cutoff_date_key: cutoffDateKey,
        cutoff_week_key: cutoffWeekKey,
        deleted: {
          audio_daily_aggregate: audioResult,
          slot_daily_aggregate: slotResult,
          weekly_distribution_aggregate: weeklyResult,
        },
      },
      200
    );
  } catch (e) {
    error(`tracking_retention_cleanup failed: ${String(e?.message || e)}`);
    return res.json(
      {
        ok: false,
        message: "retention cleanup failed",
      },
      500
    );
  }
};

function readEnv() {
  const endpoint = process.env.APPWRITE_ENDPOINT;
  const projectId = process.env.APPWRITE_PROJECT_ID;
  const apiKey = process.env.APPWRITE_API_KEY;
  if (!endpoint || !projectId || !apiKey) {
    throw new Error("Missing Appwrite env vars");
  }

  const retention = Number(
    process.env.APP_TRACKING_RETENTION_MONTHS || DEFAULT_RETENTION_MONTHS
  );
  const dryRun =
    String(process.env.APP_TRACKING_RETENTION_DRY_RUN || "false").toLowerCase() ===
    "true";

  return {
    endpoint: endpoint.replace(/\/$/, ""),
    projectId,
    apiKey,
    databaseId: process.env.APPWRITE_DATABASE_ID || DEFAULT_DATABASE_ID,
    audioDailyTableId:
      process.env.APPWRITE_AUDIO_DAILY_TABLE_ID || DEFAULT_AUDIO_TABLE_ID,
    slotDailyTableId:
      process.env.APPWRITE_SLOT_DAILY_TABLE_ID || DEFAULT_SLOT_TABLE_ID,
    weeklyDistributionTableId:
      process.env.APPWRITE_WEEKLY_DISTRIBUTION_TABLE_ID || DEFAULT_WEEKLY_TABLE_ID,
    retentionMonths: Number.isFinite(retention) && retention > 0 ? retention : 12,
    dryRun,
  };
}

function buildCutoffDate(retentionMonths) {
  const now = new Date();
  return new Date(
    Date.UTC(now.getUTCFullYear(), now.getUTCMonth() - retentionMonths, now.getUTCDate())
  );
}

function formatDateKey(date) {
  const y = String(date.getUTCFullYear()).padStart(4, "0");
  const m = String(date.getUTCMonth() + 1).padStart(2, "0");
  const d = String(date.getUTCDate()).padStart(2, "0");
  return `${y}-${m}-${d}`;
}

function formatWeekKey(date) {
  const weekInfo = getIsoWeek(date);
  return `${weekInfo.year}-W${String(weekInfo.week).padStart(2, "0")}`;
}

function getIsoWeek(dateInput) {
  const date = new Date(
    Date.UTC(dateInput.getUTCFullYear(), dateInput.getUTCMonth(), dateInput.getUTCDate())
  );
  const dayNum = date.getUTCDay() || 7;
  date.setUTCDate(date.getUTCDate() + 4 - dayNum);
  const yearStart = new Date(Date.UTC(date.getUTCFullYear(), 0, 1));
  const weekNo = Math.ceil(((date - yearStart) / 86400000 + 1) / 7);
  return {
    year: date.getUTCFullYear(),
    week: weekNo,
  };
}

async function cleanupByDateKey({ env, tableId, cutoffDateKey, dryRun, log }) {
  const rows = await listAllRows({ env, tableId });
  const oldRows = rows.filter((row) => {
    const dateKey = row?.date_key;
    return typeof dateKey === "string" && dateKey < cutoffDateKey;
  });
  if (dryRun) return { matched: oldRows.length, deleted: 0 };

  let deleted = 0;
  for (const row of oldRows) {
    const rowId = row?.$id;
    if (!rowId) continue;
    const deletedOk = await deleteRow({ env, tableId, rowId });
    if (deletedOk) {
      deleted += 1;
    } else {
      log(`delete failed for ${tableId}/${rowId}`);
    }
  }
  return { matched: oldRows.length, deleted };
}

async function cleanupByWeekKey({ env, tableId, cutoffWeekKey, dryRun, log }) {
  const rows = await listAllRows({ env, tableId });
  const oldRows = rows.filter((row) => {
    const weekKey = row?.week_key;
    return typeof weekKey === "string" && weekKey < cutoffWeekKey;
  });
  if (dryRun) return { matched: oldRows.length, deleted: 0 };

  let deleted = 0;
  for (const row of oldRows) {
    const rowId = row?.$id;
    if (!rowId) continue;
    const deletedOk = await deleteRow({ env, tableId, rowId });
    if (deletedOk) {
      deleted += 1;
    } else {
      log(`delete failed for ${tableId}/${rowId}`);
    }
  }
  return { matched: oldRows.length, deleted };
}

async function listAllRows({ env, tableId }) {
  const rows = [];
  const pageSize = 100;
  let offset = 0;
  for (;;) {
    const response = await appwriteRequest({
      method: "GET",
      env,
      path: `/databases/${env.databaseId}/tables/${tableId}/rows`,
      queryParametersAll: {
        "queries[]": [queryLimit(pageSize), queryOffset(offset)],
      },
    });
    if (!response.ok) {
      throw new Error(
        `listAllRows failed (${tableId}): ${response.statusCode} ${response.body}`
      );
    }
    const pageRows = Array.isArray(response.json?.rows) ? response.json.rows : [];
    if (pageRows.length === 0) break;
    rows.push(...pageRows);
    if (pageRows.length < pageSize) break;
    offset += pageSize;
  }
  return rows;
}

function queryLimit(n) {
  return JSON.stringify({
    method: "limit",
    values: [n],
  });
}

function queryOffset(n) {
  return JSON.stringify({
    method: "offset",
    values: [n],
  });
}

async function deleteRow({ env, tableId, rowId }) {
  const response = await appwriteRequest({
    method: "DELETE",
    env,
    path: `/databases/${env.databaseId}/tables/${tableId}/rows/${rowId}`,
  });
  return response.ok || response.statusCode === 404;
}

async function appwriteRequest({ method, env, path, body, queryParametersAll }) {
  let uri = `${env.endpoint}${path}`;
  if (queryParametersAll && Object.keys(queryParametersAll).length > 0) {
    const parts = [];
    for (const [key, values] of Object.entries(queryParametersAll)) {
      for (const value of values) {
        parts.push(
          `${encodeURIComponent(key)}=${encodeURIComponent(String(value))}`
        );
      }
    }
    uri = `${uri}?${parts.join("&")}`;
  }

  const response = await fetch(uri, {
    method,
    headers: {
      "Content-Type": "application/json",
      "X-Appwrite-Project": env.projectId,
      "X-Appwrite-Key": env.apiKey,
    },
    body: body ? JSON.stringify(body) : undefined,
  });
  const text = await response.text();
  let json = null;
  if (text) {
    try {
      json = JSON.parse(text);
    } catch (_) {
      json = null;
    }
  }
  return {
    ok: response.ok,
    statusCode: response.status,
    body: text,
    json,
  };
}
