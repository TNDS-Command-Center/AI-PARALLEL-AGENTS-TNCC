# AI Parallel Development Instructions

**Version**: 1.0
**Owner**: True North Data Strategies

---

## What This Is

You are part of a multi-agent parallel development system. Multiple AI agents work on the same project simultaneously without conflicts. This document defines your role, your file zones, and how you coordinate with the other agent.

**Copy this document into each agent's context at the start of every session.**

---

## Agent Roles

### Agent A: Frontend / UI Track
- **Owns**: Components, pages, styles, client-side state, user interactions
- **File Zones**: `src/components/`, `src/pages/`, `src/styles/`, `src/hooks/`, `src/context/`, `public/`
- **Coordinates with Agent B on**: API contracts, shared types, data shapes

### Agent B: Backend / Data Track
- **Owns**: API endpoints, database schemas, business logic, server utilities
- **File Zones**: `src/api/`, `src/server/`, `src/db/`, `src/lib/`, `src/middleware/`, `prisma/`
- **Coordinates with Agent A on**: Response formats, auth flows, error shapes

### Shared Zones (Requires Coordination)
- `src/types/` — Shared type definitions (coordinate before modifying)
- `src/utils/` — Shared utility functions (claim in the log before editing)
- Config files at root (`package.json`, `.env`, etc.) — discuss before changing

---

## File Zone Rules

1. **Stay in your zone** — only create/modify files in your declared file zones
2. **Shared zones require a claim** — log your intent before editing shared files
3. **No root file creation** — do not create new files at the project root without discussion
4. **New directories** — propose in the coordination log before creating

---

## Task Structure

Every task follows this format:

```
### TASK-[TRACK]-[NUMBER]: [Name]

**Agent**: [A / B]
**Dependencies**: [List completed tasks this requires]
**Duration**: [Small 1-2hr / Medium 3-4hr / Large 5-8hr]

**Objective**: [One sentence — what gets built]

**Entry Conditions**:
- [ ] Previous task complete
- [ ] Required dependencies available

**Acceptance Criteria**:
1. [Specific, testable outcome]
2. [Specific, testable outcome]
3. [Specific, testable outcome]

**Testing**:
- [How to verify this works]
```

---

## Coordination Protocol

### Shared Coordination Log

Maintain `AGENT_COORDINATION_LOG.md` at the project root. Format:

```markdown
## Coordination Log

| Task ID | Agent | Status | Started | Completed | Blocks | Notes |
|---------|-------|--------|---------|-----------|--------|-------|
| A-001   | A     | Done   | 9:00    | 9:45      | —      | Nav component built |
| B-001   | B     | In Progress | 9:00 | —      | —      | Auth endpoints |
| A-002   | A     | Blocked | —      | —         | B-001  | Needs auth API |
```

**Status values**: Pending, In Progress, Done, Blocked, Waiting

### Coordination Rules

1. **Update the log immediately** when starting or finishing a task
2. **Flag blockers explicitly** — don't silently wait
3. **Document API contracts early** — write the response shape before the other agent needs it
4. **No silent assumptions** — if you need something from the other agent, write it in the log
5. **Claim shared files** — before editing anything in a shared zone, log your intent

---

## API Contract Format

When Agent B creates an endpoint, document it immediately:

```markdown
## API: [Endpoint Name]

**Method**: GET/POST/PUT/DELETE
**Path**: /api/[resource]
**Auth**: Required / Public

**Request Body**:
```json
{
  "field": "type"
}
```

**Response (200)**:
```json
{
  "data": {},
  "message": "string"
}
```

**Error Response (4xx/5xx)**:
```json
{
  "error": "string",
  "code": "string"
}
```
```

Agent A should check for API contracts before building UI that calls an endpoint.

---

## Task Completion Protocol

Every completed task produces THREE things:

### 1. Completion Record

```markdown
## TASK-[X]-[N] Completion Record

**What was built**: [Summary]
**Files created/modified**: [List]
**Key decisions**: [Rationale for non-obvious choices]
**Issues encountered**: [Problems and solutions]
**Other agent needs to know**: [Dependencies, contracts, gotchas]
**Test results**: [What was tested and outcome]
```

### 2. Next Task Prompt

Generate a clear prompt for the next task in your track. It must include:
- Context from what you just finished
- What files/state are available
- What to build next
- Acceptance criteria
- How to test

**The prompt must be clear enough that a fresh AI agent with zero prior context can execute it without asking questions.**

### 3. Coordination Log Update

Mark your task done. Flag if it unblocks other tasks.

---

## Integration Checkpoints

At defined milestones, both agents stop and verify their work integrates:

1. **Define the checkpoint** at sprint planning (e.g., "after A-004 + B-003")
2. **Both agents stop** current work
3. **Run integration tests** — does frontend talk to backend correctly?
4. **Document results** — pass, fail, issues found
5. **Create fix tasks** if integration fails
6. **Proceed** only after checkpoint passes

---

## Dependency Handling

### Within your track
Sequential — TASK-A-002 depends on TASK-A-001. Finish in order.

### Cross-track
Explicit — if TASK-A-005 needs TASK-B-003's API:
- Mark it in the coordination log: "A-005 BLOCKED by B-003"
- Agent A picks up a different parallel task while waiting
- Agent B flags when B-003 is done
- Agent A resumes A-005

### Breaking changes
If you need to change something the other agent depends on:
- Document the change in the coordination log
- Create a fix task for the affected agent
- Don't proceed until acknowledged

---

## Emergency Protocols

### Conflict Detected
Stop. Document what conflicted and why. Don't try to resolve alone — flag it in the coordination log for human review.

### Integration Failure
1. Identify which task introduced the regression
2. Create a hotfix task for the responsible agent
3. Rerun the checkpoint after the fix

### Agent Blocked with No Parallel Work
Document the blocker. Don't generate filler work. Wait or escalate.

---

## Quality Checklist

Before marking any task complete:

- [ ] Acceptance criteria met
- [ ] Tests passing
- [ ] Completion record written
- [ ] Next prompt generated
- [ ] Coordination log updated
- [ ] No conflicts with other agent's work
- [ ] Error handling implemented
- [ ] Code commented where non-obvious
- [ ] Files stay within declared zone

---

## Starting a Task

When you receive a task prompt:

1. Read the full prompt and verify you understand the objective
2. Check the coordination log for conflicts or blockers
3. Verify entry conditions are met
4. Confirm you're working within your file zones
5. Execute the task
6. Complete the handoff protocol (record + next prompt + log update)

## Completing a Task

When you finish:

1. Verify all acceptance criteria
2. Write completion record
3. Generate next prompt
4. Update coordination log
5. State clearly: **"TASK-[X] complete. Handoff ready."**

---

**Owner**: Jacob Johnston
**Email**: jacob@truenorthstrategyops.com
**Organization**: True North Data Strategies
