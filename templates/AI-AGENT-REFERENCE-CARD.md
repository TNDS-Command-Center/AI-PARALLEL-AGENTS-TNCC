# AI Agent Reference Card

One-page cheat sheet for the AI Parallel Development Framework.
Print this or keep it open alongside your agent chat windows.

---

## Your Role

| If you are... | You own... | Your file zones |
|---------------|-----------|-----------------|
| **Agent A** (Frontend) | UI, components, pages, styles, client state | `src/components/`, `src/pages/`, `src/styles/`, `src/hooks/` |
| **Agent B** (Backend) | API, database, business logic, server utils | `src/api/`, `src/server/`, `src/db/`, `src/lib/` |
| **Agent C** (DevOps) | CI/CD, tests, infra, deployment | `.github/`, `tests/`, `docker/`, `infra/` |

**Shared zones** (`src/types/`, `src/utils/`, root configs) — claim in the log before editing.

---

## Task Format

```
TASK-[TRACK]-[NUMBER]: [Name]
Agent: [A/B/C]  |  Dependencies: [task IDs]  |  Duration: [S/M/L]
Objective: [one sentence]
Acceptance Criteria: [numbered list]
Testing: [how to verify]
```

---

## When You START a Task

1. Read the full prompt
2. Check coordination log for blockers
3. Verify entry conditions are met
4. Stay in your file zones
5. Execute

---

## When You FINISH a Task

Produce three things:

| # | What | Purpose |
|---|------|---------|
| 1 | **Completion Record** | What you built, decisions, issues, what other agent needs to know |
| 2 | **Next Task Prompt** | Self-contained prompt a fresh agent can execute |
| 3 | **Log Update** | Mark task Done, flag unblocked tasks |

Then say: **"TASK-[X] complete. Handoff ready."**

---

## Coordination Log Format

```
| Task ID | Agent | Status      | Started | Completed | Blocks | Notes |
|---------|-------|-------------|---------|-----------|--------|-------|
| A-001   | A     | Done        | 9:00    | 9:45      | —      | ...   |
| B-001   | B     | In Progress | 9:00    | —         | —      | ...   |
| A-002   | A     | Blocked     | —       | —         | B-001  | ...   |
```

**Statuses**: Pending | In Progress | Done | Blocked | Waiting

---

## Rules (The Short Version)

1. **Stay in your zone** — don't touch files outside your declared zones
2. **Update the log immediately** — when starting, finishing, or getting blocked
3. **Flag blockers explicitly** — never silently wait
4. **Document API contracts early** — before the other agent needs them
5. **No silent assumptions** — write it in the log or it didn't happen
6. **Claim shared files** — log intent before editing shared zones

---

## Cross-Track Dependencies

```
A-005 needs B-003's API?
  → Log: "A-005 BLOCKED by B-003"
  → Agent A: pick up a parallel task
  → Agent B: flag when B-003 is done
  → Agent A: resume A-005
```

---

## Integration Checkpoint

1. Both agents stop
2. Test: does frontend talk to backend?
3. Document: pass/fail/issues
4. Fix tasks if needed
5. Proceed only after pass

---

## Emergency Protocol

| Situation | Action |
|-----------|--------|
| **Conflict detected** | Stop. Log it. Don't resolve alone — flag for human review. |
| **Integration failure** | Identify regression task. Create hotfix. Rerun checkpoint. |
| **Blocked, no parallel work** | Document blocker. Don't generate filler. Wait or escalate. |

---

## Quality Checklist (Before Marking Done)

- [ ] Acceptance criteria met
- [ ] Tests passing
- [ ] Completion record written
- [ ] Next prompt generated
- [ ] Coordination log updated
- [ ] No zone violations
- [ ] Error handling done

---

**Framework**: TNDS Parallel Development Framework
**Owner**: Jacob Johnston | True North Data Strategies
