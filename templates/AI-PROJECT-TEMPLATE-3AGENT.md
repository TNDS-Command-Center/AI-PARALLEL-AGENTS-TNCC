# AI Parallel Development Instructions — 3-Agent Variant

**Version**: 1.0
**Owner**: True North Data Strategies

---

## What This Is

You are part of a multi-agent parallel development system with **three agents** working on the same project simultaneously. This variant adds a DevOps/Testing track to the standard Frontend + Backend split.

**Copy this document into each agent's context at the start of every session.**

---

## Agent Roles

### Agent A: Frontend / UI Track
- **Owns**: Components, pages, styles, client-side state, user interactions
- **File Zones**: `src/components/`, `src/pages/`, `src/styles/`, `src/hooks/`, `src/context/`, `public/`
- **Coordinates with B on**: API contracts, shared types, data shapes
- **Coordinates with C on**: Environment variables, build config, E2E test selectors

### Agent B: Backend / Data Track
- **Owns**: API endpoints, database schemas, business logic, server utilities
- **File Zones**: `src/api/`, `src/server/`, `src/db/`, `src/lib/`, `src/middleware/`, `prisma/`
- **Coordinates with A on**: Response formats, auth flows, error shapes
- **Coordinates with C on**: Database migrations, API health checks, deployment readiness

### Agent C: DevOps / Testing Track
- **Owns**: CI/CD pipelines, test suites, infrastructure, deployment, monitoring
- **File Zones**: `.github/`, `tests/`, `docker/`, `infra/`, `scripts/`, `Dockerfile`, `docker-compose.yml`
- **Coordinates with A on**: E2E test coverage, build pipeline, static analysis
- **Coordinates with B on**: Database setup scripts, API smoke tests, health endpoints

### Shared Zones (Requires Coordination)
- `src/types/` — Shared type definitions (coordinate before modifying)
- `src/utils/` — Shared utility functions (claim in the log before editing)
- Config files at root (`package.json`, `.env`, `tsconfig.json`) — discuss before changing
- `README.md` — Agent C owns, but A and B may request updates

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
```

---

## Coordination Protocol

### Three-Way Coordination Log

Maintain `AGENT_COORDINATION_LOG.md` at the project root. Format:

```markdown
## Coordination Log

| Task ID | Agent | Status | Started | Completed | Blocks | Notes |
|---------|-------|--------|---------|-----------|--------|-------|
| A-001   | A     | Done   | 9:00    | 9:45      | —      | Nav component built |
| B-001   | B     | In Progress | 9:00 | —      | —      | Auth endpoints |
| C-001   | C     | Done   | 9:00    | 10:00     | —      | CI pipeline + Dockerfile |
| A-002   | A     | Blocked | —      | —         | B-001  | Needs auth API |
```

**Status values**: Pending, In Progress, Done, Blocked, Waiting

### Coordination Rules

1. **Update the log immediately** when starting or finishing a task
2. **Flag blockers explicitly** — don't silently wait
3. **Document API contracts early** — Agent B writes response shapes before Agent A needs them
4. **No silent assumptions** — if you need something from another agent, write it in the log
5. **Claim shared files** — before editing anything in a shared zone, log your intent
6. **Agent C runs tests against A and B work** — coordinate timing to avoid testing stale code

---

## Agent C: DevOps Sprint Plan

Agent C typically works in this order:

### Sprint Start (Parallel with A-001 and B-001)
1. **C-001**: Project infrastructure — Dockerfile, docker-compose, CI pipeline skeleton
2. **C-002**: Test framework setup — Jest/Vitest config, test utilities, first smoke test
3. **C-003**: Linting and formatting — ESLint, Prettier, pre-commit hooks

### Mid-Sprint (After A and B have code to test)
4. **C-004**: Unit test stubs for Agent A components
5. **C-005**: API integration tests for Agent B endpoints
6. **C-006**: E2E test skeleton (Playwright/Cypress)

### Pre-Checkpoint
7. **C-007**: Run full test suite, report results to log
8. **C-008**: Verify builds pass in CI

### Post-Checkpoint
9. **C-009**: Deployment pipeline (staging environment)
10. **C-010**: Monitoring and health checks

---

## Integration Checkpoints

With three agents, checkpoints are more structured:

1. **Define the checkpoint** at sprint planning (e.g., "after A-004 + B-003 + C-007")
2. **All three agents stop** current work
3. **Agent C runs the full test suite** and reports results
4. **Verify integration**: frontend → backend → database → CI pipeline
5. **Document results** — pass, fail, issues found per track
6. **Create fix tasks** assigned to the responsible agent
7. **Proceed** only after checkpoint passes

### Checkpoint Report Format

```markdown
## Checkpoint CP-[N] Report

**Date**: [date]
**Tasks Completed**: A-001 through A-004, B-001 through B-003, C-001 through C-007

### Results
| Check | Status | Notes |
|-------|--------|-------|
| Frontend builds | PASS/FAIL | |
| Backend starts | PASS/FAIL | |
| API tests pass | PASS/FAIL | |
| E2E tests pass | PASS/FAIL | |
| CI pipeline passes | PASS/FAIL | |
| Docker build works | PASS/FAIL | |

### Issues Found
1. [Issue description — assigned to Agent X]

### Fix Tasks Created
- TASK-[X]-FIX-[N]: [description]
```

---

## Task Completion Protocol

Every completed task produces THREE things:

### 1. Completion Record
- What was created or modified
- Key decisions and rationale
- Issues encountered and how resolved
- What other agents need to know
- Test results

### 2. Next Task Prompt
Self-contained prompt for the next task. Must include context, files available, what to build, acceptance criteria, and how to test.

### 3. Coordination Log Update
Mark task done. Flag if it unblocks tasks on other tracks.

---

## Dependency Handling

### Within your track
Sequential — TASK-A-002 depends on TASK-A-001.

### Cross-track (Three-Way)
- A → B: Frontend needs backend API (most common)
- B → C: Backend needs CI pipeline or test infrastructure
- C → A: DevOps needs frontend build output for E2E tests
- C → B: DevOps needs backend running for integration tests

**Rule**: If blocked cross-track, pick up a parallel task in your own track. Log the blocker explicitly.

### Breaking Changes
If you need to change something another agent depends on:
- Document the change in the coordination log
- Create a fix task for the affected agent(s)
- Don't proceed until acknowledged

---

## Emergency Protocols

### Conflict Detected
Stop. Document what conflicted and why. Flag for human review.

### Integration Failure
1. Agent C identifies which task introduced the regression
2. Create a hotfix task for the responsible agent
3. Rerun the checkpoint after the fix

### Agent Blocked with No Parallel Work
Document the blocker. Don't generate filler work. Wait or escalate.

---

## Quality Checklist

Before marking any task complete:

- [ ] Acceptance criteria met
- [ ] Tests passing (Agent C confirms for integration/E2E)
- [ ] Completion record written
- [ ] Next prompt generated
- [ ] Coordination log updated
- [ ] No conflicts with other agents' work
- [ ] No zone violations
- [ ] Error handling implemented

---

**Owner**: Jacob Johnston
**Email**: jacob@truenorthstrategyops.com
**Organization**: True North Data Strategies
