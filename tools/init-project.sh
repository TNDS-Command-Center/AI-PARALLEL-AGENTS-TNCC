#!/usr/bin/env bash
#
# init-project.sh — Initialize a new project with the AI Parallel Development Framework
#
# Usage:
#   ./init-project.sh ~/Desktop/my-project
#   ./init-project.sh ~/Desktop/my-project AI-PROJECT-TEMPLATE-3AGENT.md
#
# Arguments:
#   $1  Project path (required)
#   $2  Template name (optional, default: AI-PROJECT-TEMPLATE-PROMPT.md)
#
# Owner: Jacob Johnston | True North Data Strategies

set -euo pipefail

# --- Args ---
PROJECT_PATH="${1:-}"
TEMPLATE="${2:-AI-PROJECT-TEMPLATE-PROMPT.md}"

if [ -z "$PROJECT_PATH" ]; then
    echo "Usage: $0 <project-path> [template-name]"
    echo ""
    echo "Templates:"
    echo "  AI-PROJECT-TEMPLATE-PROMPT.md       (default) 2-agent with file zones"
    echo "  AI-PROJECT-TEMPLATE-3AGENT.md        3-agent variant"
    echo "  AI-AGENT-NO-FILE-RULES-PROMPT.md     Coordination-only, no file rules"
    echo "  AI-PROJECT-TEMPLATE-TNDS-CLIENT.md   TNDS Command Center variant"
    exit 1
fi

# --- Resolve paths ---
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
FRAMEWORK_ROOT="$(dirname "$SCRIPT_DIR")"
TEMPLATE_PATH="$FRAMEWORK_ROOT/templates/$TEMPLATE"

# --- Validate template ---
if [ ! -f "$TEMPLATE_PATH" ]; then
    echo "Error: Template not found: $TEMPLATE_PATH"
    echo "Available templates:"
    ls "$FRAMEWORK_ROOT/templates/"*.md 2>/dev/null | while read -r f; do
        echo "  - $(basename "$f")"
    done
    exit 1
fi

# --- Create project directory ---
if [ -d "$PROJECT_PATH" ]; then
    echo "Warning: Directory already exists: $PROJECT_PATH"
    read -rp "Continue and add framework files? (y/N) " confirm
    if [ "$confirm" != "y" ]; then
        exit 0
    fi
else
    mkdir -p "$PROJECT_PATH"
    echo -e "\033[32mCreated project directory: $PROJECT_PATH\033[0m"
fi

# --- Create subdirectories ---
for dir in docs notes tools archive; do
    if [ ! -d "$PROJECT_PATH/$dir" ]; then
        mkdir -p "$PROJECT_PATH/$dir"
        echo -e "  \033[36mCreated: $dir/\033[0m"
    fi
done

# --- Copy template as AI-INSTRUCTIONS.md ---
cp "$TEMPLATE_PATH" "$PROJECT_PATH/AI-INSTRUCTIONS.md"
echo -e "  \033[36mCopied: AI-INSTRUCTIONS.md (from $TEMPLATE)\033[0m"

# --- Create coordination log ---
LOG_PATH="$PROJECT_PATH/AGENT_COORDINATION_LOG.md"
if [ ! -f "$LOG_PATH" ]; then
    PROJECT_NAME="$(basename "$PROJECT_PATH")"
    TODAY="$(date +%Y-%m-%d)"
    cat > "$LOG_PATH" << EOF
# Agent Coordination Log

**Project**: $PROJECT_NAME
**Created**: $TODAY
**Template**: $TEMPLATE

---

## Active Sprint

| Task ID | Agent | Status | Started | Completed | Blocks | Notes |
|---------|-------|--------|---------|-----------|--------|-------|
| A-001   | A     | Pending | —      | —         | —      |       |
| B-001   | B     | Pending | —      | —         | —      |       |

---

## API Contracts

*(Agent B: document endpoint contracts here as you build them)*

---

## Integration Checkpoints

| Checkpoint | After Tasks | Status | Date | Notes |
|------------|-------------|--------|------|-------|
| CP-1       | A-003 + B-002 | Pending | — | — |

---

## Notes & Decisions

*(Log important decisions, architecture choices, and anything both agents need to know)*
EOF
    echo -e "  \033[36mCreated: AGENT_COORDINATION_LOG.md\033[0m"
fi

# --- Create Agent A prompt stub ---
PROMPT_A="$PROJECT_PATH/PROMPT-AGENT-A.md"
if [ ! -f "$PROMPT_A" ]; then
    cat > "$PROMPT_A" << 'EOF'
# Agent A — First Task Prompt

## Context
You are Agent A (Frontend / UI Track) in a parallel development system.
Read AI-INSTRUCTIONS.md for the full coordination protocol.

## TASK-A-001: [Name Your First Frontend Task]

**Agent**: A
**Dependencies**: None
**Duration**: Small (1-2hr)

**Objective**: [What should Agent A build first?]

**Entry Conditions**:
- [ ] Project directory created
- [ ] AI-INSTRUCTIONS.md reviewed

**Acceptance Criteria**:
1. [Specific, testable outcome]
2. [Specific, testable outcome]
3. [Specific, testable outcome]

**Testing**:
- [How to verify this works]

---

*Fill in the bracketed sections before pasting into your AI chat window.*
EOF
    echo -e "  \033[36mCreated: PROMPT-AGENT-A.md\033[0m"
fi

# --- Create Agent B prompt stub ---
PROMPT_B="$PROJECT_PATH/PROMPT-AGENT-B.md"
if [ ! -f "$PROMPT_B" ]; then
    cat > "$PROMPT_B" << 'EOF'
# Agent B — First Task Prompt

## Context
You are Agent B (Backend / Data Track) in a parallel development system.
Read AI-INSTRUCTIONS.md for the full coordination protocol.

## TASK-B-001: [Name Your First Backend Task]

**Agent**: B
**Dependencies**: None
**Duration**: Small (1-2hr)

**Objective**: [What should Agent B build first?]

**Entry Conditions**:
- [ ] Project directory created
- [ ] AI-INSTRUCTIONS.md reviewed

**Acceptance Criteria**:
1. [Specific, testable outcome]
2. [Specific, testable outcome]
3. [Specific, testable outcome]

**Testing**:
- [How to verify this works]

**API Contract** (publish for Agent A):
```
[METHOD] /api/[endpoint]
Body: { }
Response 200: { }
```

---

*Fill in the bracketed sections before pasting into your AI chat window.*
EOF
    echo -e "  \033[36mCreated: PROMPT-AGENT-B.md\033[0m"
fi

# --- Summary ---
echo ""
echo -e "\033[32mFramework initialized!\033[0m"
echo -e "\033[32mProject: $PROJECT_PATH\033[0m"
echo ""
echo -e "\033[33mNext steps:\033[0m"
echo "  1. Edit AI-INSTRUCTIONS.md — customize file zones for your project"
echo "  2. Edit PROMPT-AGENT-A.md — define Agent A's first task"
echo "  3. Edit PROMPT-AGENT-B.md — define Agent B's first task"
echo "  4. Open two AI chat windows and paste the instructions + prompts"
echo ""
