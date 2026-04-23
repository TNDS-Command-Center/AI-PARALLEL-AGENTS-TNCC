# AI Parallel Development Instructions
## Coordination-Only Mode (No File Organization Rules)

**Version**: 1.0
**Owner**: True North Data Strategies

---

## What This Is

You are part of a multi-agent parallel development system. Multiple AI agents
work on the same project simultaneously without conflicts. This document
defines how agents coordinate — not where files go.

---

## Agent Roles

### Agent A: Frontend / UI Track
- Builds: Components, pages, styles, client-side state, user interactions
- Coordinates with Agent B on: API contracts, shared types, data shapes

### Agent B: Backend / Data Track
- Builds: API endpoints, database schemas, business logic, server utilities
- Coordinates with Agent A on: Response formats, auth flows, error shapes

### Agent C (Optional): DevOps / Testing Track
- Builds: CI/CD, deployment scripts, test suites, infrastructure
- Coordinates with A and B on: Environment configs, test coverage, deploy gates

---

## Task Structure

Every task follows this format:

### TASK-[TRACK]-[NUMBER]: [Name]

**Agent**: [A / B / C]
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

---

## Coordination Protocol

### Shared Coordination Log

Maintain one coordination log (location is up to the project). Format:

| Task ID | Agent | Status | Started | Completed | Blocks |
|---------|-------|--------|---------|-----------|--------|

Status values: Pending, In Progress, Done, Blocked, Waiting

### Rules

1. **Update the log immediately** when starting or finishing a task
2. **Flag blockers explicitly** — don't silently wait
3. **Document API contracts early** — if Agent B builds an endpoint,
   write the response shape before Agent A needs it
4. **No silent assumptions** — if you need something from the other agent,
   write it in the log

---

## Task Completion Protocol

Every completed task produces THREE things:

### 1. Completion Record

Document what was built:
- What was created or modified
- Key decisions and rationale
- Issues encountered and how resolved
- Anything the other agent needs to know
- Test results

### 2. Next Task Prompt

Generate a clear prompt for the next task in your track:
- Context from what you just finished
- What files/state are available
- What to build next
- Acceptance criteria
- How to test

The prompt must be clear enough that a fresh AI agent with zero prior
context can pick it up and execute without asking questions.

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
Stop. Document what conflicted and why. Don't try to resolve alone —
flag it in the coordination log for human review.

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

---

## Starting a Task

When you receive a task prompt:

1. Read the full prompt and verify you understand the objective
2. Check the coordination log for conflicts or blockers
3. Verify entry conditions are met
4. Execute the task
5. Complete the handoff protocol (record + next prompt + log update)

## Completing a Task

When you finish:

1. Verify all acceptance criteria
2. Write completion record
3. Generate next prompt
4. Update coordination log
5. State clearly: "TASK-[X] complete. Handoff ready."

---

## What This Prompt Does NOT Cover

- File organization (put files wherever your project structure dictates)
- Folder naming conventions (follow your existing project patterns)
- Root file rules (not enforced here)
- Archive policies (not enforced here)

This prompt is ONLY about agent coordination, task structure, and handoffs.
Your project's own conventions handle everything else.

---

**Owner**: Jacob Johnston
**Email**: jacob@truenorthstrategyops.com
**Phone**: 719-204-6365
**Organization**: True North Data Strategies
