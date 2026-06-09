# Todo API — Navi example project

A deliberately tiny Flask API used to demonstrate what Navi produces on a real codebase.

```bash
pip install flask
python app.py        # http://localhost:5000
```

## The point of this folder
Open this directory in Claude Code and run:
```
/navi review app.py
```
Navi reads [`navi.project.md`](navi.project.md) as Project Law, runs the REVIEW protocols, and writes a
report under [`docs/reports/EXP/`](docs/reports/EXP/). The committed report there is the actual output —
read it to see the structure (scorecard, evidence-backed findings with line numbers, blast-audit, backlog)
before you point Navi at your own code.

[`app.py`](app.py) ships with a few intentional issues (unvalidated input, no auth, debug server) so the
review has something concrete to find.
