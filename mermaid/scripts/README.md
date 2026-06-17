# Mermaid Validation Script

Helper scripts for validating Mermaid diagrams with comprehensive error reporting.

## validate_mermaid.sh (Linux/macOS)

A validation script that can validate:
- Single Mermaid diagram strings from stdin
- Single Mermaid diagram files (.mmd, .mermaid)
- Markdown files with embedded Mermaid diagrams (.md)

### Usage

**Validate from stdin (recommended for inline diagrams):**
```bash
echo "flowchart TD; A-->B" | ./validate_mermaid.sh
```

**Validate from heredoc:**
```bash
./validate_mermaid.sh <<'EOF'
flowchart LR
    A[Start] --> B[End]
EOF
```

**Validate a single .mmd file:**
```bash
./validate_mermaid.sh diagram.mmd
```

**Validate all diagrams in a markdown file:**
```bash
./validate_mermaid.sh document.md
```

### Features

- Color-coded output (green for success, red for errors, yellow for info)
- Counts total diagrams and failed validations
- Extracts error messages from mermaid-cli
- Supports multiple input formats (stdin, .mmd, .md)
- Exit code 0 on success, 1 on failure
- Automatic cleanup of temporary files

### Requirements

- Node.js and npx (for @mermaid-js/mermaid-cli)
- Bash 4.0+

## validate_mermaid.ps1 (Windows)

A PowerShell validation script that can validate:
- Single Mermaid diagram strings from stdin
- Single Mermaid diagram files (.mmd, .mermaid)
- Markdown files with embedded diagrams (.md)

### Usage

**Validate from stdin (recommended for inline diagrams):**
```powershell
"flowchart TD; A-->B" | ./validate_mermaid.ps1
```

**Validate from here-string:**
```powershell
@'
flowchart LR
    A[Start] --> B[End]
'@ | ./validate_mermaid.ps1
```

**Validate a single .mmd file:**
```powershell
./validate_mermaid.ps1 diagram.mmd
```

**Validate all diagrams in a markdown file:**
```powershell
./validate_mermaid.ps1 document.md
```

### Requirements

- Node.js and npx (for @mermaid-js/mermaid-cli)
- PowerShell 5.0+

### Examples

**Example 1: Valid diagram from stdin**
```bash
$ echo "flowchart TD; A-->B" | ./validate_mermaid.sh
✅ Diagram stdin: Valid
```

**Example 2: Invalid diagram from stdin**
```bash
$ echo "flowchart TD; A<-!->B" | ./validate_mermaid.sh
❌ Diagram stdin: Invalid
Error: Parse error on line 1:
flowchart TD; A<-\!->B
-----------------^
```

**Example 3: Valid diagram file**
```bash
$ cat diagram.mmd
flowchart LR
    A --> B
    B --> C

$ ./validate_mermaid.sh diagram.mmd
✅ Diagram diagram.mmd: Valid
```

**Example 4: Markdown with multiple diagrams**
```bash
$ ./validate_mermaid.sh examples.md
Validating Mermaid diagrams in: examples.md

✅ Diagram 1: Valid

✅ Diagram 2: Valid

❌ Diagram 3: Invalid
Error: Parse error on line 2

================================
Validation Summary
================================
Total:  3
Passed: 2
Failed: 1
================================
```

## Integration with Claude Code

The scripts are designed to be called from the Mermaid skill:

**Linux/macOS:**
```bash
# From skill instructions (SKILL.md)
echo 'flowchart TD
    A --> B' | base/skills/mermaid/scripts/validate_mermaid.sh
```

Or with heredoc for multi-line diagrams:

```bash
base/skills/mermaid/scripts/validate_mermaid.sh <<'EOF'
sequenceDiagram
    Alice->>Bob: Hello
    Bob->>Alice: Hi
EOF
```

**Windows (PowerShell):**
```powershell
# From skill instructions (SKILL.md)
"flowchart TD
    A --> B" | base/skills/mermaid/scripts/validate_mermaid.ps1
```

Or with here-string for multi-line diagrams:

```powershell
@'
sequenceDiagram
    Alice->>Bob: Hello
    Bob->>Alice: Hi
'@ | base/skills/mermaid/scripts/validate_mermaid.ps1
```

## Error Handling

The scripts provide detailed error messages from mermaid-cli, including:
- Line number where the error occurred
- The specific syntax that caused the error
- Expected tokens vs. what was found
- Stack trace for debugging (when available)

## Performance

- Single diagrams validate in ~2-5 seconds
- Markdown files with multiple diagrams validate sequentially
- Temporary files are automatically cleaned up after validation
- Uses `-q` (quiet) flag to suppress unnecessary mermaid-cli output
