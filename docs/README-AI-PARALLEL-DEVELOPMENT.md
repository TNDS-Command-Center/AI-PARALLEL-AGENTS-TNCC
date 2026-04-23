# AI Parallel Development — Framework Deep-Dive

## The Problem

You're using AI to build software. It's fast — until it isn't. One chat window becomes a bottleneck. You open a second window and now two agents are editing the same files, making conflicting assumptions, and producing code that doesn't integrate.

**Parallel AI development without coordination is chaos.**

## The Solution

This framework gives AI agents the same thing human dev teams have had for decades: clear ownership, structured communication, and integration checkpoints. The difference is that AI agents need it spelled out explicitly — they won't infer coordination protocols from context.

---

## Core Concepts

### 1. Agent Tracks

Each agent owns a track — a vertical slice of the project with clear boundaries.

| Track | Typical Ownership | File Zones |
|-------|-------------------|------------|
| Frontend (A) | UI components, pages, styles, client state | `src/components/`, `src/pages/`, `src/styles/` |
| Backend (B) | API endpoints, database, business logic | `src/api/`, `src/server/`, `src/db/` |
| DevOps (C) | CI/CD, testing, infrastructure | `.github/`, `tests/`, `docker/`, `infra/` |

Tracks prevent conflicts by ensuring agents don't modify the same files simultaneously.

### 2. File Zones

Every agent has declared file zones — directories they own. Rules:

- **Own zone**: Create/modify freely
- **Shared zone** (`src/types/`, `src/utils/`): Claim in the log before editing
- **Other agent's zone**: Never touch without coordination

This is the simplest possible conflict prevention. No git branching strategies, no merge tooling — just clear ownership.

### 3. Coordination Log

A shared markdown file (`AGENT_COORDINATION_LOG.md`) that serves as the single source of truth for:

- Task status (Pending, In Progress, Done, Blocked)
- Blockers and dependencies
- API contracts
- Integration checkpoint results

The human coordinator keeps this file updated based on agent outputs. Agents reference it at the start of every task.

### 4. Task Prompts

Every task is a self-contained prompt that includes:

- **Objective**: What to build
- **Entry conditions**: What must be true before starting
- **Acceptance criteria**: How to verify it works
- **Dependencies**: What tasks must be complete first
- **Testing**: How to validate

A fresh agent with zero history should be able to execute any task prompt without asking questions. This is critical — AI chat sessions expire, context windows fill up, and you need to be able to hand off work cleanly.

### 5. Completion Protocol

When an agent finishes a task, it produces three artifacts:

1. **Completion Record**: What was built, decisions made, issues encountered
2. **Next Task Prompt**: Self-contained prompt for the next task in the track
3. **Log Update**: Status change for the coordination log

This ensures continuity even if you start a new chat session.

### 6. Integration Checkpoints

At defined milestones, all agents stop and the human verifies:

- Does the frontend call the backend correctly?
- Do shared types match?
- Do tests pass?
- Are there any silent conflicts?

If integration fails, fix tasks are created and assigned before any agent continues.

---

## Why This Works

### It mirrors proven software engineering practices

- **Track ownership** = team/service ownership
- **File zones** = code ownership (CODEOWNERS)
- **Coordination log** = standup + Jira board
- **Integration checkpoints** = CI/CD gates
- **Task prompts** = well-written tickets

### It accounts for AI limitations

- **No implicit context sharing** — agents don't share memory, so everything is explicit
- **Session boundaries** — agents lose context when windows close, so prompts are self-contained
- **No real-time communication** — agents can't talk to each other, so the human coordinator bridges the gap
- **Tendency to assume** — the "no silent assumptions" rule forces agents to document dependencies

---

## Scaling Beyond Two Agents

The 2-agent setup is the default because it covers most projects. When you need more:

### Three Agents
Use `AI-PROJECT-TEMPLATE-3AGENT.md`. Adds a DevOps/Testing track that handles:
- CI/CD pipeline setup
- Test suite creation
- Docker/deployment configuration
- Environment management

### When NOT to add more agents
- If tasks are mostly sequential (each depends on the previous)
- If the codebase is small enough that file zones would overlap significantly
- If you can't keep the coordination log updated — more agents = more coordination overhead

---

## Anti-Patterns

### "Just open another chat window"
Without the framework, the second agent will: create duplicate files, make conflicting API assumptions, and produce code that fails at integration.

### Skipping integration checkpoints
"Both agents are moving fast, let's skip the checkpoint." This is how you end up with a frontend calling endpoints that don't exist and a backend returning shapes the frontend can't parse.

### Vague task prompts
"Build the dashboard" is not a task prompt. "Build the dashboard overview page with four KPI cards fetching from GET /api/metrics/overview, displaying totalUsers, revenue, activeSessions, and conversionRate as formatted numbers with loading skeletons" is a task prompt.

### Agent editing shared files without claiming
Two agents editing `package.json` simultaneously = guaranteed conflict. The framework prevents this with the claim-before-edit rule for shared zones.

---

## Provider Compatibility

This framework works with any LLM that can follow structured instructions:

| Provider | Notes |
|----------|-------|
| Claude (Anthropic) | Excellent at following the protocol. Best at generating self-contained prompts. |
| ChatGPT (OpenAI) | Works well. May need reminders about the coordination log. |
| Ollama (Local) | Works for smaller tasks. Larger models (13B+) follow the protocol more reliably. |
| Any other LLM | If it can read markdown and follow instructions, it works. |

You can mix providers — Agent A on Claude, Agent B on ChatGPT. The framework is the coordination layer, not the execution layer.

---

## Frequently Asked Questions

**Q: Can I use this with a single agent?**
Yes. The task structure, completion protocol, and self-contained prompts are valuable even with one agent. You just skip the coordination log.

**Q: What if I need to refactor and file zones change?**
Pause both agents. Update the file zones in the instructions. Update the coordination log. Resume.

**Q: How do I handle database migrations?**
Migrations are Agent B's responsibility. If Agent A needs a schema change, they log the request. Agent B creates the migration and publishes the updated schema.

**Q: Can agents run on different machines?**
Yes. The coordination happens through the log file and task prompts, not through shared compute. Run Agent A on your Mac and Agent B on your Windows machine.

---

**Owner**: Jacob Johnston
**Email**: jacob@truenorthstrategyops.com
**Organization**: True North Data Strategies
