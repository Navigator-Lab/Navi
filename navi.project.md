# navi.project.md — Navi (self-overlay)

> Navi loads this right after project detection as its **Project Law**. Navi's core (`.agent/`)
> stays project-agnostic; everything project-specific to *building Navi itself* lives here.

## Identity
- **name**: Navi
- **one-liner**: Universal engineering intent router — plain words in, the right protocol-driven output out.
- **stack**: Markdown workflow + protocol library (`.agent/`); future `@navi-dev/cli` (Node) + thin cloud sync (Pro).

## Commands
- **install**: _(none yet — Phase D will add `npx navi init`)_
- **test**: _(none yet — protocols are prose; add CLI tests in Phase D)_
- **run / dev**: open Claude Code here → `/navi <request>`
- **build**: _(n/a until CLI)_
- **lint / typecheck**: `.agent/scripts/check-version.sh` (version-drift gate)

## Layout
- **entrypoint**: `.agent/workflows/navi.md` (the brain, v28)
- **source roots**: `.agent/protocols/` (P00–P14), `.agent/workflows/`, `.agent/templates/`
- **command + agents**: `.claude/commands/navi.md`, `.claude/agents/navi-{research,audit,debug}.md`
- **memory + reports**: `docs/` (STATUS/CHANGELOG/TODO/DECISIONS/DEFERRED + `docs/reports/`), scaffolded from `.agent/templates/docs/`
- **config / env**: none; real secrets (future cloud) live in `.secrets/` — never committed

## Hard Rules ("Schema Lock") — what Navi must never violate here
1. **Stay project-agnostic in `.agent/`.** Zero project-specific content (no stack/host/framework/client names) in any shipped file — that's the whole product. Project-specifics go in a `navi.project.md`, never the core.
2. **`navi.md` is the single source of truth** for version, boot line, routing, tiers. The `/navi` command stays a version-less pointer to it.
3. **OSS core = MIT; future cloud layer = Elastic License 2.0.** Never paywall a feature that already works locally.
4. **No auto-spend / no auto-send** (P00): never push, publish to npm, deploy, or call paid APIs unprompted — surface the command.

## Danger Zones (confirm before touching)
- Publishing: `git push`, `npm publish`, creating the public GitHub repo — human-approved only.
- Renaming/restructuring protocols (P00–P14) — wide blast radius; run the version gate after.
- Stripping contamination — back up before bulk edits; verify the grep returns zero hits.

## Notes
- Locked decisions & roadmap live in the local `docs/` memory (`DECISIONS.md`, `docs/reports/`).
- A fresh session resumes from `docs/STATUS.md` — read it first.
