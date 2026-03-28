# TNDS Parallel Development Framework

**Run multiple AI agents on the same project without conflicts.**

## What This Is

A provider-agnostic framework for coordinating 2-3 AI agents (Claude, ChatGPT, Ollama, or any LLM) working on the same codebase simultaneously. Each agent owns a track (frontend, backend, devops), follows structured task prompts, and coordinates through a shared log — no merge conflicts, no duplicated work, no silent assumptions.

## Who It's For

- Solo developers using multiple AI chat windows to build faster
- Teams adopting AI-assisted parallel development
- Pipeline Punks students learning multi-agent workflows
- Anyone tired of AI agents stepping on each other's work

## Quick Start

```bash
# Clone the framework
git clone https://github.com/TNDS-Command-Center/tnds-parallel-dev-framework.git

# Set up a new project (Windows)
.\tools\init-project.ps1 -ProjectPath "C:\Users\you\Desktop\my-project"

# Set up a new project (Mac/Linux)
./tools/init-project.sh ~/Desktop/my-project
```

Then open the generated `AI-INSTRUCTIONS.md` in your project and paste it into each agent's context.

## What's Inside

```
templates/
  AI-PROJECT-TEMPLATE-PROMPT.md        # Full 2-agent template with file zones
  AI-PROJECT-TEMPLATE-3AGENT.md        # 3-agent variant (Frontend/Backend/DevOps)
  AI-PROJECT-TEMPLATE-TNDS-CLIENT.md   # TNDS Command Center variant
  AI-AGENT-REFERENCE-CARD.md           # One-page cheat sheet
  AI-AGENT-NO-FILE-RULES-PROMPT.md     # Coordination-only (no file org rules)

examples/
  AI-AGENT-EXAMPLE-SAAS-DASHBOARD.md   # Full SaaS dashboard walkthrough

docs/
  QUICKSTART.md                        # Setup guide
  README-AI-PARALLEL-DEVELOPMENT.md    # Framework deep-dive

tools/
  init-project.ps1                     # Windows project scaffolding
  init-project.sh                      # Mac/Linux project scaffolding
```

## How It Works

1. **Pick a template** — 2-agent, 3-agent, or coordination-only
2. **Run the setup script** — creates project structure + coordination log
3. **Open two (or three) AI chat windows** — paste the instructions into each
4. **Assign tracks** — Agent A gets frontend, Agent B gets backend
5. **Work in parallel** — agents follow the task protocol and update the shared log
6. **Hit integration checkpoints** — verify everything connects, then continue

## Core Principles

- **No silent assumptions** — if an agent needs something, it writes it in the log
- **Structured handoffs** — every completed task produces a completion record, next prompt, and log update
- **File zone ownership** — each agent has declared file zones to prevent conflicts
- **Integration checkpoints** — periodic stops to verify frontend talks to backend
- **Provider-agnostic** — works with any LLM that can follow instructions

## Hardware Notes

| Machine | Best For |
|---------|----------|
| Windows Desktop (4070, 12GB VRAM) | Heavy code generation, larger Ollama models (up to 16B quantized) |
| Mac Air M2 (16GB) | Frontend work, prompt writing, smaller models (7-8B), reviewing logs |
| Mac Air M2 (8GB) | Same as above, close Ollama when not in active use |

## License

Internal framework — True North Data Strategies.

## Contact

**Owner**: Jacob Johnston
**Email**: jacob@truenorthstrategyops.com
**Organization**: True North Data Strategies
# AI-PARALLEL-AGENTS-TNCC
