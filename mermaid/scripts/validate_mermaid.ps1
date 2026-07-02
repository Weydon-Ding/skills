#!/usr/bin/env pwsh

# Mermaid Diagram Validation Script
# Supports: stdin, single diagram files (.mmd), and markdown files with embedded diagrams

# Colors for output
$RED = "`e[0;31m"
$GREEN = "`e[0;32m"
$YELLOW = "`e[1;33m"
$NC = "`e[0m" # No Color

# Track results (initialized in begin block)
$script:PASSED = 0
$script:FAILED = 0
$script:TOTAL = 0

function Initialize-PuppeteerBrowserPath {
  if ($env:PUPPETEER_EXECUTABLE_PATH -and (Test-Path $env:PUPPETEER_EXECUTABLE_PATH -PathType Leaf)) {
    return
  }

  $candidates = @(@(
    (Get-Command chrome -ErrorAction SilentlyContinue).Source,
    (Get-Command chrome.exe -ErrorAction SilentlyContinue).Source,
    (Get-Command msedge -ErrorAction SilentlyContinue).Source,
    (Get-Command msedge.exe -ErrorAction SilentlyContinue).Source,
    "C:\Program Files\Google\Chrome\Application\chrome.exe",
    "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe",
    "C:\Program Files\Microsoft\Edge\Application\msedge.exe",
    "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
  ) | Where-Object { $_ -and (Test-Path $_ -PathType Leaf) } | Select-Object -Unique)

  if ($candidates.Count -gt 0) {
    $env:PUPPETEER_EXECUTABLE_PATH = [string]$candidates[0]
  }
}

# Function to validate a single diagram string
function Validate-DiagramString {
  param(
    [string]$diagramContent,
    [string]$diagramLabel
  )

  # Create temp file for diagram
  $tempDiagram = New-TemporaryFile | Rename-Item -NewName { $_.Name + ".mmd" } -PassThru
  $tempOutput = New-TemporaryFile | Rename-Item -NewName { $_.Name + ".svg" } -PassThru
  $tempErrors = New-TemporaryFile

  # Write diagram to temp file
  $diagramContent | Out-File -FilePath $tempDiagram -Encoding UTF8

  # Run mermaid-cli validation
  try {
    # Run mermaid-cli validation
    & npx -y @mermaid-js/mermaid-cli@latest -i "$tempDiagram" -o "$tempOutput" -q 2>&1 | Out-File -FilePath $tempErrors -Encoding UTF8
    $exitCode = $LASTEXITCODE

    if ($exitCode -eq 0) {
      # Check if output file was created successfully
      if (Test-Path $tempOutput -PathType Leaf) {
        $outputSize = (Get-Item $tempOutput).Length
        if ($outputSize -gt 0) {
          Write-Host -ForegroundColor Green "[OK] ${diagramLabel}: Valid"
          Remove-Item -Path $tempDiagram, $tempOutput, $tempErrors -Force -ErrorAction SilentlyContinue
          return $true
        } else {
          Write-Host -ForegroundColor Red "[FAIL] ${diagramLabel}: Invalid - Output file not generated"
          Get-Content $tempErrors | Write-Host
          Remove-Item -Path $tempDiagram, $tempOutput, $tempErrors -Force -ErrorAction SilentlyContinue
          return $false
        }
      } else {
        Write-Host -ForegroundColor Red "[FAIL] ${diagramLabel}: Invalid - Output file not generated"
        Get-Content $tempErrors | Write-Host
        Remove-Item -Path $tempDiagram, $tempOutput, $tempErrors -Force -ErrorAction SilentlyContinue
        return $false
      }
    } else {
      # Command failed
      Write-Host -ForegroundColor Red "[FAIL] ${diagramLabel}: Invalid"
      Get-Content $tempErrors | Write-Host
      Remove-Item -Path $tempDiagram, $tempOutput, $tempErrors -Force -ErrorAction SilentlyContinue
      return $false
    }
  } catch {
    Write-Host -ForegroundColor Red "[FAIL] ${diagramLabel}: Invalid - Error running validation"
    Write-Host $_.Exception.Message
    Remove-Item -Path $tempDiagram, $tempOutput, $tempErrors -Force -ErrorAction SilentlyContinue
    return $false
  }
}

# Function to extract and validate diagrams from markdown
function Validate-MarkdownDiagrams {
  param(
    [string]$markdownFile
  )

  Write-Host -ForegroundColor Yellow "Validating Mermaid diagrams in: $markdownFile"
  Write-Host

  # Extract all mermaid code blocks
  $diagramNum = 0
  $inMermaid = $false
  $currentDiagram = ""

  Get-Content -Path $markdownFile | ForEach-Object {
    $line = $_
    if ($line -match '^```mermaid') {
      $inMermaid = $true
      $currentDiagram = ""
      $diagramNum++
    } elseif ($line -match '^```$' -and $inMermaid) {
      $inMermaid = $false
      $script:TOTAL++
      if (Validate-DiagramString -diagramContent $currentDiagram -diagramLabel "Diagram $diagramNum") {
        $script:PASSED++
      } else {
        $script:FAILED++
      }
      Write-Host
    } elseif ($inMermaid) {
      $currentDiagram += $line + "`n"
    }
  }

  if ($diagramNum -eq 0) {
    Write-Host -ForegroundColor Yellow "[WARN] No Mermaid diagrams found in $markdownFile"
    return $false
  }
}

# Main logic
function Main {
  # Check if file path is provided
  if ($args.Length -eq 0) {
    # No arguments provided, show usage
    Write-Host "Usage: $($MyInvocation.MyCommand.Name) <file.mmd|file.md>"
    Write-Host "   or: echo 'diagram' | $($MyInvocation.MyCommand.Name)"
    Write-Host "   or: Get-Content diagram.mmd | $($MyInvocation.MyCommand.Name)"
    exit 1
  } else {
    # Input from file
    $inputFile = $args[0]

    if (-not (Test-Path $inputFile -PathType Leaf)) {
      Write-Host -ForegroundColor Red "[FAIL] File not found: $inputFile"
      exit 1
    }

    # Determine file type and validate accordingly
    if ($inputFile -match '\.md$') {
      # Markdown file - extract and validate all diagrams
      Validate-MarkdownDiagrams -markdownFile $inputFile
    } elseif ($inputFile -match '\.(mmd|mermaid)$') {
      # Single diagram file
      $diagramContent = Get-Content -Path $inputFile -Raw
      $script:TOTAL++
      if (Validate-DiagramString -diagramContent $diagramContent -diagramLabel "Diagram $(Split-Path $inputFile -Leaf)") {
        $script:PASSED++
      } else {
        $script:FAILED++
      }
    } else {
      Write-Host -ForegroundColor Yellow "[WARN] Unknown file type. Treating as single diagram."
      $diagramContent = Get-Content -Path $inputFile -Raw
      $script:TOTAL++
      if (Validate-DiagramString -diagramContent $diagramContent -diagramLabel "Diagram $(Split-Path $inputFile -Leaf)") {
        $script:PASSED++
      } else {
        $script:FAILED++
      }
    }
  }

  # Print summary if multiple diagrams
  if ($TOTAL -gt 1) {
    Write-Host "================================"
    Write-Host "Validation Summary"
    Write-Host "================================"
    Write-Host "Total:  $TOTAL"
    Write-Host -ForegroundColor Green "Passed: $PASSED"
    Write-Host -ForegroundColor Red "Failed: $FAILED"
    Write-Host "================================"
  }

  # Exit with appropriate code
  if ($FAILED -gt 0) {
    exit 1
  } else {
    exit 0
  }
}

# Run main function
Initialize-PuppeteerBrowserPath

# Check if we have pipeline input
$pipedInput = $input | Out-String
if ($pipedInput -ne "") {
  # We have pipeline input, validate it
  $script:TOTAL++
  if (Validate-DiagramString -diagramContent $pipedInput -diagramLabel "Diagram stdin") {
    $script:PASSED++
    exit 0
  } else {
    $script:FAILED++
    exit 1
  }
} else {
  # No pipeline input, run main with arguments
  Main @args
}
