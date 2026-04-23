<#
.SYNOPSIS
    Initialize a new project with the AI Parallel Development Framework.

.DESCRIPTION
    Creates project directory structure, copies agent instructions from the
    framework template, initializes the coordination log, and generates
    starter prompt stubs for Agent A and Agent B.

.PARAMETER ProjectPath
    Full path to the new project directory.

.PARAMETER Template
    Template variant to use. Default: AI-PROJECT-TEMPLATE-PROMPT.md
    Options: AI-PROJECT-TEMPLATE-PROMPT.md, AI-PROJECT-TEMPLATE-3AGENT.md,
             AI-AGENT-NO-FILE-RULES-PROMPT.md

.EXAMPLE
    .\init-project.ps1 -ProjectPath "C:\Users\you\Desktop\my-project"

.EXAMPLE
    .\init-project.ps1 -ProjectPath "C:\Users\you\Desktop\my-project" -Template "AI-PROJECT-TEMPLATE-3AGENT.md"

.NOTES
    Owner: Jacob Johnston | True North Data Strategies
#>

param(
    [Parameter(Mandatory = $true)]
    [string]$ProjectPath,

    [Parameter(Mandatory = $false)]
    [string]$Template = "AI-PROJECT-TEMPLATE-PROMPT.md"
)

$ErrorActionPreference = "Stop"

# Resolve paths
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$FrameworkRoot = Split-Path -Parent $ScriptDir
$TemplatePath = Join-Path $FrameworkRoot "templates" $Template

# Validate template exists
if (-not (Test-Path $TemplatePath)) {
    Write-Error "Template not found: $TemplatePath"
    Write-Host "Available templates:"
    Get-ChildItem (Join-Path $FrameworkRoot "templates") -Filter "*.md" | ForEach-Object { Write-Host "  - $($_.Name)" }
    exit 1
}

# Create project directory
if (Test-Path $ProjectPath) {
    Write-Warning "Directory already exists: $ProjectPath"
    $confirm = Read-Host "Continue and add framework files? (y/N)"
    if ($confirm -ne "y") { exit 0 }
} else {
    New-Item -ItemType Directory -Path $ProjectPath -Force | Out-Null
    Write-Host "Created project directory: $ProjectPath" -ForegroundColor Green
}

# Create subdirectories
$dirs = @("docs", "notes", "tools", "archive")
foreach ($dir in $dirs) {
    $dirPath = Join-Path $ProjectPath $dir
    if (-not (Test-Path $dirPath)) {
        New-Item -ItemType Directory -Path $dirPath -Force | Out-Null
        Write-Host "  Created: $dir/" -ForegroundColor Cyan
    }
}

# Copy template as AI-INSTRUCTIONS.md
$instructionsPath = Join-Path $ProjectPath "AI-INSTRUCTIONS.md"
Copy-Item $TemplatePath $instructionsPath -Force
Write-Host "  Copied: AI-INSTRUCTIONS.md (from $Template)" -ForegroundColor Cyan

# Create coordination log
$logPath = Join-Path $ProjectPath "AGENT_COORDINATION_LOG.md"
if (-not (Test-Path $logPath)) {
    $logContent = @"
# Agent Coordination Log

**Project**: $(Split-Path -Leaf $ProjectPath)
**Created**: $(Get-Date -Format "yyyy-MM-dd")
**Template**: $Template

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
"@
    Set-Content -Path $logPath -Value $logContent -Encoding UTF8
    Write-Host "  Created: AGENT_COORDINATION_LOG.md" -ForegroundColor Cyan
}

# Create Agent A prompt stub
$promptAPath = Join-Path $ProjectPath "PROMPT-AGENT-A.md"
if (-not (Test-Path $promptAPath)) {
    $promptAContent = @"
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
"@
    Set-Content -Path $promptAPath -Value $promptAContent -Encoding UTF8
    Write-Host "  Created: PROMPT-AGENT-A.md" -ForegroundColor Cyan
}

# Create Agent B prompt stub
$promptBPath = Join-Path $ProjectPath "PROMPT-AGENT-B.md"
if (-not (Test-Path $promptBPath)) {
    $promptBContent = @"
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
``````
[METHOD] /api/[endpoint]
Body: { }
Response 200: { }
``````

---

*Fill in the bracketed sections before pasting into your AI chat window.*
"@
    Set-Content -Path $promptBPath -Value $promptBContent -Encoding UTF8
    Write-Host "  Created: PROMPT-AGENT-B.md" -ForegroundColor Cyan
}

# Summary
Write-Host ""
Write-Host "Framework initialized!" -ForegroundColor Green
Write-Host "Project: $ProjectPath" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "  1. Edit AI-INSTRUCTIONS.md — customize file zones for your project"
Write-Host "  2. Edit PROMPT-AGENT-A.md — define Agent A's first task"
Write-Host "  3. Edit PROMPT-AGENT-B.md — define Agent B's first task"
Write-Host "  4. Open two AI chat windows and paste the instructions + prompts"
Write-Host ""
