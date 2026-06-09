# EXP — Todo API code review

**Date:** 2026-06-09 · **Mode:** REVIEW (Standard tier) · **Protocols:** P04 + P07 + karpathy
**Topic:** Correctness, security, and simplicity audit of `app.py` (Flask Todo API).

<success_criteria>Every endpoint in `app.py` assessed for correctness + security; each finding has a file:line, a severity, and a fix direction; a blast-audit confirms whether each defect class recurs; output ends with a prioritized backlog.</success_criteria>
<output_contract>This report under `docs/reports/EXP/` + an in-chat summary. No code changes. Ends with "Say PLAN to implement."</output_contract>
<assumptions>Project Law = `examples/todo-api/navi.project.md` (Python/Flask, single-file, in-memory store). The in-memory store and "no DB" are accepted demo constraints, not defects; thread-safety is judged against Flask's default multi-worker deployment.</assumptions>

---

## Phase 0 — Anchor & Scope
One file, three endpoints (`GET /todos`, `POST /todos`, `DELETE /todos/<id>`). Project Law sets three hard
rules: (1) validate every request body, (2) never run `debug=True` outside local dev, (3) no secrets in
source. Scope = `app.py` against those rules + the P07 quality gates.

## Phase 2 — Validation (best-practice grounding)
- Flask security docs warn the interactive debugger (`debug=True`) allows **arbitrary code execution** if
  ever reachable from an untrusted client — never enable it in production.
  ([Flask — Debug Mode](https://flask.palletsprojects.com/en/latest/quickstart/#debug-mode))
- `request.get_json()` returns `None` (or aborts 415) when the body isn't JSON, so indexing its result
  without a guard is a documented footgun.
  ([Flask — request.get_json](https://flask.palletsprojects.com/en/latest/api/#flask.Request.get_json))

## Phase 3 — Analysis Lenses

**Correctness.** `POST /todos` reads `data["title"]` directly (`app.py:26`). If the client sends no JSON,
the wrong content-type, or omits `title`, `data` is `None` or the key is missing → unhandled
`TypeError`/`KeyError` → HTTP 500 instead of a clean 400. This also violates Hard Rule 1.

**Security.** (a) `app.run(debug=True)` (`app.py:39`) ships the Werkzeug debugger — RCE if the host is ever
exposed; violates Hard Rule 2. (b) No authentication or authorization on any route — `DELETE /todos/<id>`
(`app.py:34`) lets any caller delete any item. Acceptable for a local demo, flagged for any real use.

**Simplicity / Karpathy.** The code is appropriately minimal — no speculative abstraction. `global _next_id`
(`app.py:24`) is the one smell: it is not concurrency-safe under Flask's default multi-worker serving (two
requests can read the same id). Fine for the demo; would need an atomic source (DB sequence) for real use.

## Phase 4 — Scorecard
| Dimension | Status | Notes |
|---|---|---|
| Correctness | ⚠️ | Unvalidated request body → 500 on malformed input (`app.py:25-26`) |
| Security | ❌ | Debugger in `run` (`app.py:39`); no auth on any endpoint incl. DELETE |
| Simplicity | ✅ | Minimal, readable; no over-engineering |
| Concurrency | ⚠️ | `global _next_id` race under multi-worker (`app.py:24`) |
| API hygiene | ⚠️ | No pagination on `GET /todos`; no consistent error envelope |

## Phase 5 — Findings (evidence-backed)
| # | Severity | File:line | Finding | Fix direction |
|---|---|---|---|---|
| 1 | HIGH | `app.py:39` | `debug=True` enables the Werkzeug debugger (RCE risk); breaks Hard Rule 2 | Gate on an env flag: `debug=os.environ.get("FLASK_DEBUG")=="1"` |
| 2 | HIGH | `app.py:25-26` | Unvalidated `request.get_json()` / `data["title"]` → 500 on bad input; breaks Hard Rule 1 | Guard: reject non-JSON / missing `title` with a 400 + error envelope |
| 3 | MED | `app.py:34` | No auth on `DELETE` (or any route) — any caller can delete any todo | Add an auth guard (out of demo scope; note in README) |
| 4 | LOW | `app.py:24` | `global _next_id` not concurrency-safe under multiple workers | Use an atomic id source (DB sequence / UUID) when leaving in-memory |

### M0 Blast-Audit (does the defect class recur?)
- **Signature:** unguarded subscripting of `request.get_json()` (`data["..."]` with no validation).
- **Sweep:** `grep -n "get_json" app.py` → **1 occurrence** (the `POST` handler). No siblings — finding #2 is
  the only instance. (On a larger codebase this step fixes or schedules every match with exact counts.)

## Phase 6 — Backlog (prioritized)
1. **#2 input validation** — smallest surface, prevents 500s; do first.
2. **#1 debug flag** — one-line env gate; required before any non-local run.
3. **#3 auth** — design decision; needed before exposing the API.
4. **#4 id source** — only when the in-memory store is replaced.

## Phase 7 — References
- Flask Debug Mode — https://flask.palletsprojects.com/en/latest/quickstart/#debug-mode
- Flask `request.get_json` — https://flask.palletsprojects.com/en/latest/api/#flask.Request.get_json
- OWASP A01:2021 Broken Access Control — https://owasp.org/Top10/A01_2021-Broken_Access_Control/

---
**Say PLAN to implement.**
