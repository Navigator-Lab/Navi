# Quickstart — your first 5 minutes with Navi

Navi turns plain-language intent into structured, protocol-driven output. You don't pick a mode or a
template — you say what you want, and Navi routes it. Here's the whole loop.

> **Prerequisite:** [Claude Code](https://docs.claude.com/en/docs/claude-code) (CLI, desktop, or IDE
> extension). Navi is pure Markdown — nothing to install or build.

## 1. Get Navi into your workspace
```bash
git clone https://github.com/Navigator-Lab/Navi.git
cd Navi
```
Or copy the `.agent/` and `.claude/` folders into a project you already have.

## 2. Open the folder in Claude Code
Open this directory in Claude Code (any host). The `/navi` slash command is wired via
`.claude/commands/navi.md`.

## 3. Ask for something in plain words
```
/navi explain how the intent router decides a tier
/navi review this diff
/navi plan adding a CLI installer
```
Navi detects your project, scores the intent (EXPLAIN · RESEARCH · PLAN · BUILD · DEBUG · VERIFY ·
REVIEW · REFACTOR · OPERATE), picks a tier, loads only the protocols it needs, and prints a **boot line**
so you can see exactly what it's doing:
```
🧭 Navi v28 | project=<name> | stack=<…> | mode=EXPLAIN | tier=Lite (read-only) | protocols=P02
```

## 4. Read the output
Every non-trivial request resolves to **one** primary artifact — an **EXP** (understand) or a **PLAN**
(act) — saved under `docs/reports/{EXP,PLAN,…}/`. A fresh session resumes from `docs/STATUS.md` with zero
re-explanation. See a real one in [`examples/todo-api/`](examples/todo-api/).

## 5. Onboard your own project
Drop a [`navi.project.md`](.agent/templates/navi.project.md) in your project root — stack, build/test/run
commands, hard rules, danger zones. Navi loads it right after detection. **No edit to the core is ever
needed for a new project.**

---

### What to try next
| You want to… | Say |
|---|---|
| Understand a file/flow | `/navi explain <file or behavior>` |
| Find the root cause of a bug | `/navi why does <X> fail` |
| Plan a change before coding | `/navi plan <change>` |
| Audit code quality/security | `/navi review <area>` |
| Run / start the app | `/navi run` |

Safety is built in: Navi never pushes to git, deploys, publishes, or calls paid APIs unprompted — it
surfaces the command for you to run. See [`.agent/protocols/ADR-P00-Master-Rule.md`](.agent/protocols/ADR-P00-Master-Rule.md).
