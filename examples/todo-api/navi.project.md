# navi.project.md — Todo API (example)

> Navi loads this right after project detection as its **Project Law** for this folder.
> It's a minimal but complete overlay — copy its shape for your own projects.

## Identity
- **name**: Todo API
- **one-liner**: A tiny Flask REST API for todo items (Navi demo project).
- **stack**: Python 3.11 · Flask

## Commands
- **install**: `pip install flask`
- **run / dev**: `python app.py`  (serves on http://localhost:5000)
- **test**: _(none yet — add `pytest` for a real project)_
- **lint / typecheck**: `ruff check . && mypy app.py`

## Layout
- **entrypoint**: `app.py`
- **source roots**: `.` (single file)
- **config / env**: none; real secrets would live in `.env` (gitignored)

## Hard Rules ("Schema Lock")
1. Every endpoint validates its request body before use — no unguarded `data["..."]`.
2. Never run the debug server (`debug=True`) outside local development.
3. No secrets in source; configuration comes from the environment.

## Danger Zones (confirm before touching)
- Swapping the in-memory store for a database (data-layer change — wide blast radius).
- Adding auth (changes the contract of every endpoint).
