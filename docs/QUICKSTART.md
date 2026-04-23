# Quickstart Guide — AI Parallel Development Framework

Get two AI agents building your project in parallel in under 10 minutes.

---

## Prerequisites

- Git installed
- A project idea or existing codebase
- Two AI chat windows (Claude, ChatGPT, Ollama, or any mix)

---

## Step 1: Clone the Framework

```bash
git clone https://github.com/TNDS-Command-Center/tnds-parallel-dev-framework.git
cd tnds-parallel-dev-framework
```

---

## Step 2: Initialize Your Project

### Windows (PowerShell)

```powershell
.\tools\init-project.ps1 -ProjectPath "C:\Users\you\Desktop\my-project"
```

### Mac / Linux

```bash
chmod +x tools/init-project.sh
./tools/init-project.sh ~/Desktop/my-project
```

This creates:

```
my-project/
├── docs/                           # Project documentation
├── notes/                          # Agent notes and scratch space
├── tools/                          # Scripts and utilities
├── archive/                        # Completed work archive
├── AI-INSTRUCTIONS.md              # Agent instructions (copied from template)
├── AGENT_COORDINATION_LOG.md       # Shared coordination log
├── PROMPT-AGENT-A.md               # First prompt stub for Agent A
└── PROMPT-AGENT-B.md               # First prompt stub for Agent B
```

---

## Step 3: Configure Agent Instructions

Open `AI-INSTRUCTIONS.md` in your project and customize:

1. **Update file zones** to match your project structure
2. **Define Sprint 1 tasks** — what does each agent build first?
3. **Set the first integration checkpoint** — when should agents stop and verify?

---

## Step 4: Start Your Agents

### Agent A (Frontend)

1. Open a new AI chat window
2. Paste the contents of `AI-INSTRUCTIONS.md`
3. Tell the agent: *"You are Agent A (Frontend Track). Here is your first task:"*
4. Paste the contents of `PROMPT-AGENT-A.md`

### Agent B (Backend)

1. Open a second AI chat window
2. Paste the same `AI-INSTRUCTIONS.md`
3. Tell the agent: *"You are Agent B (Backend Track). Here is your first task:"*
4. Paste the contents of `PROMPT-AGENT-B.md`

---

## Step 5: Coordinate

As agents complete tasks, they'll produce:

1. **Completion Record** — what was built, decisions made, issues hit
2. **Next Task Prompt** — copy this into the agent's next message
3. **Coordination Log Update** — paste updates into `AGENT_COORDINATION_LOG.md`

**You are the human coordinator.** Your job:
- Copy next-task prompts between sessions
- Keep the coordination log up to date
- Call integration checkpoints when milestones are reached
- Resolve blockers and conflicts

---

## Step 6: Integration Checkpoint

When both agents hit the checkpoint milestone:

1. Stop both agents
2. Review the coordination log for conflicts
3. Test that frontend talks to backend correctly
4. Document results
5. Create fix tasks if needed
6. Resume both agents

---

## Quick Reference

| Action | How |
|--------|-----|
| Start a task | Paste task prompt into agent chat |
| Complete a task | Agent produces completion record + next prompt |
| Block on dependency | Log it, switch to a parallel task |
| Integration checkpoint | Both agents stop, test, document, continue |
| Resolve conflict | Flag in log, human decides, create fix task |
| Add Agent C | Use the 3-agent template variant |

---

## Template Variants

| Template | Use When |
|----------|----------|
| `AI-PROJECT-TEMPLATE-PROMPT.md` | Standard 2-agent build with file zones |
| `AI-PROJECT-TEMPLATE-3AGENT.md` | Need a third agent for DevOps/Testing |
| `AI-AGENT-NO-FILE-RULES-PROMPT.md` | Existing project, don't want file rules |
| `AI-PROJECT-TEMPLATE-TNDS-CLIENT.md` | TNDS Command Center client builds |

---

## Troubleshooting

**Agents editing the same file**: Check file zone definitions. If it's a shared file, one agent must claim it in the log first.

**Agent stuck waiting**: Check the coordination log for blockers. Reassign the blocked agent to a parallel task.

**Integration fails**: Don't panic. Create a fix task, assign it, rerun the checkpoint.

**Agent lost context**: Paste `AI-INSTRUCTIONS.md` again, then the specific task prompt. The framework is designed so any task prompt is self-contained.

---

**Owner**: Jacob Johnston
**Email**: jacob@truenorthstrategyops.com
**Organization**: True North Data Strategies
