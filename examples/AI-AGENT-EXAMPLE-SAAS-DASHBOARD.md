# Example: SaaS Analytics Dashboard — Parallel Build

This walkthrough demonstrates the AI Parallel Development Framework applied to a real project: building a SaaS analytics dashboard with two agents working simultaneously.

---

## Project Overview

**Product**: Analytics dashboard for a SaaS application
**Stack**: Next.js (frontend) + Express API (backend) + PostgreSQL
**Agents**: 2 (Agent A = Frontend, Agent B = Backend)
**Estimated Duration**: 2 sprints, ~20 tasks total

---

## Sprint 1: Foundation

### Agent A Tasks (Frontend Track)

#### TASK-A-001: Project Scaffolding & Layout Shell

**Agent**: A
**Dependencies**: None
**Duration**: Small (1-2hr)

**Objective**: Set up Next.js project with base layout, navigation, and routing.

**Entry Conditions**:
- [ ] Clean project directory created by init script

**Acceptance Criteria**:
1. Next.js app created with TypeScript
2. Base layout with sidebar navigation and main content area
3. Routes: `/dashboard`, `/analytics`, `/settings`, `/login`
4. Responsive sidebar that collapses on mobile
5. Tailwind CSS configured

**Testing**:
- `npm run dev` starts without errors
- All four routes render placeholder content
- Sidebar navigation works between routes

---

#### TASK-A-002: Authentication UI

**Agent**: A
**Dependencies**: TASK-A-001
**Duration**: Medium (3-4hr)

**Objective**: Build login page, signup page, and auth state management.

**Entry Conditions**:
- [ ] TASK-A-001 complete
- [ ] Auth API contract from Agent B (TASK-B-001)

**Acceptance Criteria**:
1. Login form with email/password fields and validation
2. Signup form with name/email/password/confirm fields
3. Auth context provider wrapping the app
4. Protected route wrapper redirecting unauthenticated users
5. Loading states during auth requests

**Testing**:
- Forms validate input and show error messages
- Auth context provides `user`, `login()`, `logout()`, `isLoading`
- Protected routes redirect to `/login` when not authenticated

---

#### TASK-A-003: Dashboard Overview Page

**Agent**: A
**Dependencies**: TASK-A-001, TASK-B-002 (metrics API contract)
**Duration**: Medium (3-4hr)

**Objective**: Build the main dashboard page with KPI cards and chart placeholders.

**Entry Conditions**:
- [ ] TASK-A-001 complete
- [ ] Metrics API contract available from Agent B

**Acceptance Criteria**:
1. Four KPI cards: Total Users, Revenue, Active Sessions, Conversion Rate
2. Line chart placeholder for revenue over time
3. Bar chart placeholder for user signups by week
4. Data fetching hooks calling the metrics API
5. Loading skeletons while data loads

**Testing**:
- Dashboard renders with mock data when API is unavailable
- KPI cards display formatted numbers
- Charts render placeholder data

---

### Agent B Tasks (Backend Track)

#### TASK-B-001: Auth API & Database Schema

**Agent**: B
**Dependencies**: None
**Duration**: Medium (3-4hr)

**Objective**: Build authentication endpoints and user database schema.

**Entry Conditions**:
- [ ] Clean project directory

**Acceptance Criteria**:
1. PostgreSQL schema: `users` table (id, name, email, password_hash, created_at)
2. `POST /api/auth/register` — create user, return JWT
3. `POST /api/auth/login` — validate credentials, return JWT
4. `POST /api/auth/logout` — invalidate token
5. `GET /api/auth/me` — return current user from JWT
6. JWT middleware for protected routes
7. Password hashing with bcrypt

**Testing**:
- Register creates user in database
- Login returns valid JWT
- `/me` returns user data with valid token, 401 without
- Duplicate email returns 409

**API Contract (publish immediately for Agent A)**:

```
POST /api/auth/register
Body: { name, email, password }
Response 201: { user: { id, name, email }, token: "jwt..." }
Response 409: { error: "Email already registered" }

POST /api/auth/login
Body: { email, password }
Response 200: { user: { id, name, email }, token: "jwt..." }
Response 401: { error: "Invalid credentials" }

GET /api/auth/me
Headers: Authorization: Bearer <token>
Response 200: { user: { id, name, email, created_at } }
Response 401: { error: "Unauthorized" }
```

---

#### TASK-B-002: Metrics API

**Agent**: B
**Dependencies**: TASK-B-001 (auth middleware)
**Duration**: Medium (3-4hr)

**Objective**: Build endpoints for dashboard metrics and analytics data.

**Entry Conditions**:
- [ ] TASK-B-001 complete (auth middleware available)

**Acceptance Criteria**:
1. `GET /api/metrics/overview` — KPI summary (total users, revenue, sessions, conversion)
2. `GET /api/metrics/revenue?period=7d|30d|90d` — revenue time series
3. `GET /api/metrics/signups?period=7d|30d|90d` — signup counts by period
4. All endpoints require authentication
5. Seed data script for development

**Testing**:
- Endpoints return structured data matching the contract
- Unauthenticated requests return 401
- Period parameter filters correctly

**API Contract**:

```
GET /api/metrics/overview
Response 200: {
  totalUsers: number,
  revenue: number,
  activeSessions: number,
  conversionRate: number
}

GET /api/metrics/revenue?period=30d
Response 200: {
  data: [{ date: "2025-01-01", amount: 1234.56 }, ...]
}

GET /api/metrics/signups?period=30d
Response 200: {
  data: [{ week: "2025-W01", count: 42 }, ...]
}
```

---

## Coordination Log — Sprint 1

| Task ID | Agent | Status | Started | Completed | Blocks | Notes |
|---------|-------|--------|---------|-----------|--------|-------|
| A-001 | A | Done | Day 1 09:00 | Day 1 10:30 | — | Next.js scaffold ready |
| B-001 | B | Done | Day 1 09:00 | Day 1 12:00 | — | Auth API + contract published |
| A-002 | A | Done | Day 1 10:30 | Day 1 14:00 | B-001 (resolved) | Auth UI connected |
| B-002 | B | Done | Day 1 13:00 | Day 1 16:00 | — | Metrics API + contract published |
| A-003 | A | Done | Day 1 14:30 | Day 2 10:00 | B-002 (resolved) | Dashboard page built |

### Integration Checkpoint 1 (After A-003 + B-002)

**Result**: PASS
- Login flow works end-to-end (UI → API → JWT → protected routes)
- Dashboard loads metrics from API
- Auth token passed correctly in headers
- One minor fix needed: CORS config for dev server (created TASK-B-FIX-001)

---

## Sprint 2: Features & Polish

Sprint 2 would continue with:
- **A-004**: Analytics detail page with filters and date ranges
- **A-005**: Settings page (profile, notifications, API keys)
- **B-003**: Analytics query engine with aggregation
- **B-004**: User settings CRUD endpoints
- **B-005**: Data export API (CSV/JSON)
- **Integration Checkpoint 2**: Full feature verification

---

## Key Takeaways from This Example

1. **Agent B published API contracts immediately** — Agent A never had to guess response formats
2. **Cross-track blocking was explicit** — A-002 was blocked by B-001, logged and visible
3. **Integration checkpoint caught a real issue** — CORS config was missing, caught before it snowballed
4. **Each completion record included "other agent needs to know"** — critical for async coordination
5. **Task prompts were self-contained** — a fresh agent could pick up any task without history

---

**Owner**: Jacob Johnston
**Email**: jacob@truenorthstrategyops.com
**Organization**: True North Data Strategies
