# Examples

Worked examples that show what running Navi on a real project produces — not docs *about* Navi, but the
actual artifacts it generates.

| Example | Stack | Shows |
|---|---|---|
| [`todo-api/`](todo-api/) | Python / Flask | A `navi.project.md` overlay + a real **EXP report** from `/navi review app.py` — including the concrete defects Navi found and the backlog it produced. |

## How to reproduce
```bash
# Open this repo in Claude Code, then:
cd examples/todo-api
/navi review app.py
```
Navi detects the project from `examples/todo-api/navi.project.md`, runs the REVIEW protocols
(P04 + P07 + karpathy), and writes a report under `examples/todo-api/docs/reports/EXP/`. The committed
report in that folder is exactly what that command produced.
