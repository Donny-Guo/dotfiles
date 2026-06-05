import { createHash } from "node:crypto";
import { appendFileSync, mkdirSync } from "node:fs";
import { join } from "node:path";

const hashArgs = (args) => {
  try {
    const json = JSON.stringify(args ?? null);
    return createHash("sha256").update(json).digest("hex").slice(0, 12);
  } catch {
    return "unhashable";
  }
};

const dayStamp = (d = new Date()) => {
  const y = d.getFullYear();
  const m = String(d.getMonth() + 1).padStart(2, "0");
  const day = String(d.getDate()).padStart(2, "0");
  return `${y}-${m}-${day}`;
};

const timeStamp = (d = new Date()) => {
  const h = String(d.getHours()).padStart(2, "0");
  const m = String(d.getMinutes()).padStart(2, "0");
  const s = String(d.getSeconds()).padStart(2, "0");
  return `${h}:${m}:${s}`;
};

const safe = (fn) => {
  try {
    fn();
  } catch {}
};

export const ToolLogger = async ({ directory }) => {
  const sessionAgents = new Map();
  const startTimes = new Map();
  const logDir = join(directory, ".opencode");
  const jsonlPath = join(logDir, "tool-log.jsonl");

  return {
    "chat.message": async (input) => {
      if (input.sessionID && input.agent) {
        sessionAgents.set(input.sessionID, input.agent);
      }
    },
    "tool.execute.before": async (input) => {
      startTimes.set(input.callID, Date.now());
    },
    "tool.execute.after": async (input, output) => {
      const startedAt = startTimes.get(input.callID) ?? Date.now();
      const durationMs = Date.now() - startedAt;
      startTimes.delete(input.callID);

      const entry = {
        ts: new Date().toISOString(),
        session: input.sessionID,
        agent: sessionAgents.get(input.sessionID) ?? "unknown",
        tool: input.tool,
        args_hash: hashArgs(input.args),
        ok: true,
        duration_ms: durationMs,
      };

      safe(() => {
        mkdirSync(logDir, { recursive: true });
        appendFileSync(jsonlPath, JSON.stringify(entry) + "\n", "utf8");
      });

      const title = output?.title ?? input.tool;
      const md =
        `## ${timeStamp(new Date(entry.ts))} [${entry.agent}] ${entry.tool}\n` +
        `${title} — ok (${durationMs}ms)`;

      safe(() => {
        mkdirSync(join(logDir, "sessions"), { recursive: true });
        appendFileSync(
          join(logDir, "sessions", `${dayStamp()}.md`),
          md + "\n",
          "utf8",
        );
      });
    },
  };
};
