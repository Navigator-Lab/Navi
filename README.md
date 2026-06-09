# Navi

> **Tell it what you want in plain English. It figures out the right way to respond, the right format, and the right level of rigor — automatically.**

Navi is a **universal engineering intent router** — a project-agnostic agent workflow that sits above any
codebase and turns plain-language intent into structured, protocol-driven, auditable output. It is not a
model and not a copilot; it's the reasoning layer (written in Markdown) that decides *what kind of task this
is, what rules apply, what output format is correct, and what sub-processes fire.*

## The problem it solves
1. **Intent collapse** — the AI does something adjacent to what you asked.
2. **Output chaos** — responses vary wildly in format/depth; no institutional memory.
3. **Safety erosion** — the AI runs destructive commands, pushes to git, or calls paid APIs unasked.

A routing layer (intent detection + a fixed protocol library + an output contract) eliminates all three.

## Quickstart (Claude Code)
```bash
# 1. Open this folder in Claude Code.
# 2. Run the router with plain words:
/navi explain the auth flow
/navi plan the payment integration
/navi review this diff
```
Navi detects your project, picks the intent (EXPLAIN · RESEARCH · PLAN · BUILD · DEBUG · VERIFY · REVIEW ·
REFACTOR · OPERATE), selects a tier, loads only the protocols it needs, and saves reports under `docs/reports/`.

## What's inside
| Path | What |
|------|------|
| `.agent/workflows/navi.md` | The brain (v28) — version, boot line, routing, tiers (single source of truth) |
| `.agent/protocols/` | Protocol library (P00–P07, P10, P13, P14 — lazy-loaded per intent) |
| `.claude/commands/navi.md` | The `/navi` slash command (points at the brain) |
| `.claude/agents/` | Isolated subagents: `navi-research`, `navi-audit`, `navi-debug` |
| `.agent/templates/` | `navi.project.md` overlay + `docs/` memory scaffolding |
| `navi.project.md` | This repo's own Project Law |

Run Navi in any project and it scaffolds a living **`docs/` memory** (STATUS · CHANGELOG · TODO · DECISIONS ·
DEFERRED) plus `docs/reports/` from `.agent/templates/docs/` — so a fresh session resumes from `docs/STATUS.md`
with zero re-explanation.

## Onboard any project
Drop a `navi.project.md` (template in `.agent/templates/`) in a project root: stack, commands, hard rules,
danger zones. Navi loads it after detection. **No edit to the core is ever needed for a new project.**

## License
Core: **MIT** (see [`LICENSE`](LICENSE)). A future hosted/cloud layer will be licensed separately
(**Elastic License 2.0**).

---
*Navi v28 · Host: Claude Code (host-agnostic by design).*
