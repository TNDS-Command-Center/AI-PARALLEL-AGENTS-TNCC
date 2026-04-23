# CLAUDE.md — Agent Context

## What this repo is

A provider-agnostic framework for running 2-3 AI agents on the same codebase in parallel without file conflicts, duplicated work, or silent assumptions. Not a runtime — it is markdown templates, init scripts, and a coordination protocol.

## How it's used

1. User runs `tools/init-project.ps1` (Windows) or `tools/init-project.sh` (Mac/Linux) to scaffold a new project.
2. Scripts copy one of the templates in `templates/` into the project as `AI-INSTRUCTIONS.md`, create `AGENT_COORDINATION_LOG.md`, and generate prompt stubs for each agent.
3. User pastes `AI-INSTRUCTIONS.md` into each agent chat window and hands each agent its starter prompt.
4. Agents work in their declared file zones, update the shared log, and stop at integration checkpoints.

## Repo layout

- `templates/` — four template variants (2-agent with zones, 3-agent, coordination-only, and a blank/generic variant)
- `examples/` — walkthrough applying the framework to a SaaS dashboard build
- `docs/` — quickstart and deep-dive
- `tools/` — PowerShell + bash init scripts

## When editing

- No runtime code. Changes are almost always markdown or shell/PS scripts.
- Templates are copied verbatim into user projects. Keep them self-contained — no cross-file references.
- The init scripts must remain pure — no network calls, no secrets, no writes outside the target project path.
- Don't introduce TNDS-internal references (Command Protocol stage names, internal repo names, client names). This is a public, provider-agnostic framework.

## Don't

- Don't add runtime dependencies (no Node package, no Python package). It stays a text-and-scripts framework.
- Don't embed specific LLM providers. The framework must work with Claude, ChatGPT, Ollama, or any LLM.
- Don't bake in a project type. The templates must work for Next.js, Django, Go, mobile, etc.
