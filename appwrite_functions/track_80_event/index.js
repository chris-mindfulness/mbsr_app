/**
 * Appwrite Function: track_80_event
 *
 * Zweck:
 * - Nimmt ein 80%-Tracking-Event entgegen.
 * - Aggregiert in audio_daily_aggregate und slot_daily_aggregate.
 * - Speichert keine personenbezogenen Daten.
 *
 * Erwartete ENV:
 * - APPWRITE_ENDPOINT
 * - APPWRITE_PROJECT_ID
 * - APPWRITE_API_KEY
 * - APPWRITE_DATABASE_ID (default: mbsr_database)
 * - APPWRITE_AUDIO_DAILY_TABLE_ID (default: audio_daily_aggregate)
 * - APPWRITE_SLOT_DAILY_TABLE_ID (default: slot_daily_aggregate)
 * - APPWRITE_AUDIO_PARTICIPANT_DAILY_TABLE_ID (default: audio_participant_daily_aggregate)
 * - APP_TRACKING_TIMEZONE (default: Europe/Berlin)
 * - APP_TRACKING_HASH_SALT (required for stable pseudonym hash)
 */

const crypto = require("crypto");
const DEFAULT_DATABASE_ID = "mbsr_database";
const DEFAULT_AUDIO_TABLE_ID = "audio_daily_aggregate";
const DEFAULT_SLOT_TABLE_ID = "slot_daily_aggregate";
const DEFAULT_AUDIO_PARTICIPANT_TABLE_ID = "audio_participant_daily_aggregate";
const DEFAULT_TIMEZONE = "Europe/Berlin";
const MAX_UPDATE_RETRIES = 4;

module.exports = async ({ req, res, log, error }) => {
  try {
    const env = readEnv();
    const payload = parsePayload(req);
    const valid = validatePayload(payload);
    if (!valid.ok) {
      return res.json(
        { ok: false, code: "invalid_payload", message: valid.message },
        400
      );
    }

    const eventDate = parseUtcTimestamp(payload.event_timestamp_utc);
    const dateKey = formatDateKey(eventDate, env.timezone);
    const slotKey = deriveSlotKey(eventDate, env.timezone);
    const participantHash = buildParticipantHash({
      participantRef: payload.participant_ref,
      hashSalt: env.hashSalt,
    });
    const heardSeconds = Math.max(0, Math.floor(payload.heard_seconds));
    const totalSeconds = Math.max(1, Math.floor(payload.total_seconds));

    const audioRowId = normalizeRowId(`a_${dateKey}_${payload.audio_id}`);
    const slotRowId = normalizeRowId(`s_${dateKey}_${slotKey}`);
    const participantRowId = normalizeRowId(
      `p_${dateKey}_${payload.audio_id}_${participantHash.slice(0, 12)}`
    );

    await incrementAggregateRow({
      env,
      tableId: env.audioDailyTableId,
      rowId: audioRowId,
      createData: {
        date_key: dateKey,
        audio_id: payload.audio_id,
        audio_title: payload.audio_title,
        plays_80_count: 0,
        heard_seconds_sum: 0,
        updated_at: new Date().toISOString(),
      },
      incrementData: {
        plays_80_count: 1,
        heard_seconds_sum: heardSeconds,
        updated_at: new Date().toISOString(),
      },
      log,
    });

    await incrementAggregateRow({
      env,
      tableId: env.slotDailyTableId,
      rowId: slotRowId,
      createData: {
        date_key: dateKey,
        slot_key: slotKey,
        plays_80_count: 0,
        heard_seconds_sum: 0,
        updated_at: new Date().toISOString(),
      },
      incrementData: {
        plays_80_count: 1,
        heard_seconds_sum: heardSeconds,
        updated_at: new Date().toISOString(),
      },
      log,
    });

    await incrementAggregateRow({
      env,
      tableId: env.audioParticipantDailyTableId,
      rowId: participantRowId,
      createData: {
        date_key: dateKey,
        audio_id: payload.audio_id,
        audio_title: payload.audio_title,
        participant_hash: participantHash,
        plays_80_count: 0,
        heard_seconds_sum: 0,
        updated_at: new Date().toISOString(),
      },
      incrementData: {
        plays_80_count: 1,
        heard_seconds_sum: heardSeconds,
        updated_at: new Date().toISOString(),
      },
      log,
    });

    return res.json(
      {
        ok: true,
        date_key: dateKey,
        slot_key: slotKey,
        participant_hash: participantHash,
        heard_seconds: heardSeconds,
        total_seconds: totalSeconds,
      },
      200
    );
  } catch (e) {
    error(`track_80_event failed: ${String(e?.message || e)}`);
    return res.json(
      {
        ok: false,
        code: "internal_error",
        message: "tracking function failed",
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

  return {
    endpoint: endpoint.replace(/\/$/, ""),
    projectId,
    apiKey,
    databaseId: process.env.APPWRITE_DATABASE_ID || DEFAULT_DATABASE_ID,
    audioDailyTableId:
      process.env.APPWRITE_AUDIO_DAILY_TABLE_ID || DEFAULT_AUDIO_TABLE_ID,
    slotDailyTableId:
      process.env.APPWRITE_SLOT_DAILY_TABLE_ID || DEFAULT_SLOT_TABLE_ID,
    audioParticipantDailyTableId:
      process.env.APPWRITE_AUDIO_PARTICIPANT_DAILY_TABLE_ID ||
      DEFAULT_AUDIO_PARTICIPANT_TABLE_ID,
    timezone: process.env.APP_TRACKING_TIMEZONE || DEFAULT_TIMEZONE,
    hashSalt: process.env.APP_TRACKING_HASH_SALT || "",
  };
}

function parsePayload(req) {
  const rawBody = req?.body;
  if (!rawBody) return {};

  if (typeof rawBody === "string") {
    return JSON.parse(rawBody);
  }
  if (typeof rawBody === "object") {
    return rawBody;
  }
  return {};
}

function validatePayload(payload) {
  if (!payload || typeof payload !== "object") {
    return { ok: false, message: "Body must be JSON object" };
  }
  if (!isNonEmptyString(payload.audio_id)) {
    return { ok: false, message: "audio_id missing" };
  }
  if (!isNonEmptyString(payload.audio_title)) {
    return { ok: false, message: "audio_title missing" };
  }
  if (!isNonEmptyString(payload.participant_ref)) {
    return { ok: false, message: "participant_ref missing" };
  }
  if (!isFinitePositive(payload.heard_seconds)) {
    return { ok: false, message: "heard_seconds invalid" };
  }
  if (!isFinitePositive(payload.total_seconds)) {
    return { ok: false, message: "total_seconds invalid" };
  }
  // Kein starres "heard/total >= 0.8": Die App sendet reale Hörsekunden (Integer),
  // Rundung und kurze Tracks wuerden sonst gueltige Events ablehnen.
  // Plausibilitaet: nicht deutlich laenger als die Datei.
  const heard = Number(payload.heard_seconds);
  const total = Number(payload.total_seconds);
  if (heard > total + 5) {
    return { ok: false, message: "heard_seconds implausible" };
  }
  if (!isNonEmptyString(payload.event_timestamp_utc)) {
    return { ok: false, message: "event_timestamp_utc missing" };
  }
  const parsed = Date.parse(payload.event_timestamp_utc);
  if (Number.isNaN(parsed)) {
    return { ok: false, message: "event_timestamp_utc invalid" };
  }
  return { ok: true };
}

function buildParticipantHash({ participantRef, hashSalt }) {
  const ref = String(participantRef || "").trim();
  const salt = String(hashSalt || "").trim();
  if (!ref) {
    throw new Error("participant_ref missing");
  }
  if (!salt) {
    throw new Error("APP_TRACKING_HASH_SALT missing");
  }
  return crypto.createHash("sha256").update(`${ref}:${salt}`).digest("hex");
}

function isNonEmptyString(value) {
  return typeof value === "string" && value.trim().length > 0;
}

function isFinitePositive(value) {
  const num = Number(value);
  return Number.isFinite(num) && num > 0;
}

function parseUtcTimestamp(timestampIso) {
  const parsed = new Date(timestampIso);
  if (Number.isNaN(parsed.getTime())) {
    throw new Error("Invalid event_timestamp_utc");
  }
  return parsed;
}

function formatDateKey(date, timezone) {
  const parts = new Intl.DateTimeFormat("en-CA", {
    timeZone: timezone,
    year: "numeric",
    month: "2-digit",
    day: "2-digit",
  }).formatToParts(date);

  const year = parts.find((p) => p.type === "year")?.value;
  const month = parts.find((p) => p.type === "month")?.value;
  const day = parts.find((p) => p.type === "day")?.value;
  return `${year}-${month}-${day}`;
}

function deriveSlotKey(date, timezone) {
  const hourText = new Intl.DateTimeFormat("en-US", {
    hour: "2-digit",
    hour12: false,
    timeZone: timezone,
  }).format(date);
  const hour = Number(hourText);

  if (hour >= 5 && hour <= 11) return "vormittag";
  if (hour >= 12 && hour <= 17) return "nachmittag";
  return "abend";
}

function normalizeRowId(source) {
  const clean = source
    .toLowerCase()
    .replace(/[^a-z0-9_]/g, "_")
    .replace(/_{2,}/g, "_")
    .replace(/^_+|_+$/g, "");
  if (!clean) return "row_default";
  return clean.length > 36 ? clean.slice(0, 36) : clean;
}

async function incrementAggregateRow({
  env,
  tableId,
  rowId,
  createData,
  incrementData,
  log,
}) {
  for (let attempt = 1; attempt <= MAX_UPDATE_RETRIES; attempt += 1) {
    const currentRow = await getRowById({
      env,
      tableId,
      rowId,
    });

    if (!currentRow) {
      const created = await createRow({
        env,
        tableId,
        rowId,
        data: createData,
      });
      if (created.ok) {
        // Direkt danach einmal inkrementieren, damit derselbe Codepfad gilt.
        continue;
      }
      // 409 => parallel erstellt, dann naechster Versuch.
      if (created.statusCode !== 409) {
        throw new Error(
          `createRow failed (${tableId}/${rowId}): ${created.statusCode} ${created.body}`
        );
      }
    } else {
      const merged = {
        ...currentRow.data,
        plays_80_count:
          toInt(currentRow.data?.plays_80_count) + toInt(incrementData.plays_80_count),
        heard_seconds_sum:
          toInt(currentRow.data?.heard_seconds_sum) +
          toInt(incrementData.heard_seconds_sum),
        updated_at: incrementData.updated_at,
      };

      const updated = await updateRow({
        env,
        tableId,
        rowId,
        data: merged,
      });
      if (updated.ok) return;

      if (attempt === MAX_UPDATE_RETRIES) {
        throw new Error(
          `updateRow retries exceeded (${tableId}/${rowId}): ${updated.statusCode} ${updated.body}`
        );
      }
      log(
        `retry ${attempt}/${MAX_UPDATE_RETRIES} for ${tableId}/${rowId} because update failed`
      );
      await delay(70 * attempt);
    }
  }
}

function toInt(value) {
  const n = Number(value);
  if (!Number.isFinite(n)) return 0;
  return Math.floor(n);
}

async function getRowById({ env, tableId, rowId }) {
  let response = await appwriteRequest({
    method: "GET",
    env,
    path: `/databases/${env.databaseId}/tables/${tableId}/rows/${rowId}`,
  });
  if (response.statusCode === 404) {
    response = await appwriteRequest({
      method: "GET",
      env,
      path: `/databases/${env.databaseId}/collections/${tableId}/documents/${rowId}`,
    });
  }
  if (response.statusCode === 404) return null;
  if (!response.ok) {
    throw new Error(
      `getRowById failed (${tableId}/${rowId}): ${response.statusCode} ${response.body}`
    );
  }
  return {
    data: extractDataPayload(response.json),
  };
}

async function createRow({ env, tableId, rowId, data }) {
  let response = await appwriteRequest({
    method: "POST",
    env,
    path: `/databases/${env.databaseId}/tables/${tableId}/rows`,
    body: {
      rowId,
      data,
    },
  });
  if (response.statusCode === 404) {
    response = await appwriteRequest({
      method: "POST",
      env,
      path: `/databases/${env.databaseId}/collections/${tableId}/documents`,
      body: {
        documentId: rowId,
        data,
      },
    });
  }
  return response;
}

async function updateRow({ env, tableId, rowId, data }) {
  let response = await appwriteRequest({
    method: "PATCH",
    env,
    path: `/databases/${env.databaseId}/tables/${tableId}/rows/${rowId}`,
    body: { data },
  });
  if (response.statusCode === 404) {
    response = await appwriteRequest({
      method: "PATCH",
      env,
      path: `/databases/${env.databaseId}/collections/${tableId}/documents/${rowId}`,
      body: { data },
    });
  }
  return response;
}

function extractDataPayload(json) {
  if (!json || typeof json !== "object") return {};
  if (json.data && typeof json.data === "object") {
    return json.data;
  }

  const plain = {};
  for (const [key, value] of Object.entries(json)) {
    if (!key.startsWith("$")) {
      plain[key] = value;
    }
  }
  return plain;
}

async function appwriteRequest({ method, env, path, body }) {
  const response = await fetch(`${env.endpoint}${path}`, {
    method,
    headers: {
      "Content-Type": "application/json",
      "X-Appwrite-Project": env.projectId,
      "X-Appwrite-Key": env.apiKey,
    },
    body: body ? JSON.stringify(body) : undefined,
  });

  const text = await response.text();
  let parsed = null;
  if (text) {
    try {
      parsed = JSON.parse(text);
    } catch (_) {
      parsed = null;
    }
  }

  return {
    ok: response.ok,
    statusCode: response.status,
    body: text,
    json: parsed,
  };
}

function delay(ms) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}
