<#
.SYNOPSIS
    Builds the "Eval Incarnate: A Builder's Curriculum" book as EPUB and/or PDF.

.DESCRIPTION
    Uses Pandoc to combine all Markdown files into a single book.
    Requires: pandoc (https://pandoc.org/installing.html)
    Optional: For PDF output, also needs a LaTeX distribution (MiKTeX or TeX Live)

.EXAMPLE
    .\build-book.ps1              # Build both EPUB and PDF
    .\build-book.ps1 -Format epub # Build EPUB only
    .\build-book.ps1 -Format pdf  # Build PDF only
#>

param(
    [ValidateSet("epub", "pdf", "html", "both", "all")]
    [string]$Format = "both"
)

$ErrorActionPreference = "Stop"
$BookDir = $PSScriptRoot
$OutputDir = Join-Path $BookDir "output"

# Source files in book order
$Sources = @(
    "Foreword.md",
    "Introduction.md",
    "Part_1.md",
    "Part_2.md",
    "Part_3.md",
    "Part_4.md",
    "Part_5.md"
)

# Check for pandoc
if (-not (Get-Command pandoc -ErrorAction SilentlyContinue)) {
    Write-Host ""
    Write-Host "ERROR: Pandoc is not installed or not in PATH." -ForegroundColor Red
    Write-Host ""
    Write-Host "Install it with one of these methods:" -ForegroundColor Yellow
    Write-Host "  winget install JohnMacFarlane.Pandoc"
    Write-Host "  choco install pandoc"
    Write-Host "  Or download from: https://pandoc.org/installing.html"
    Write-Host ""
    exit 1
}

# Create output directory
if (-not (Test-Path $OutputDir)) {
    New-Item -ItemType Directory -Path $OutputDir | Out-Null
}

# Verify all source files exist
foreach ($src in $Sources) {
    $path = Join-Path $BookDir $src
    if (-not (Test-Path $path)) {
        Write-Host "ERROR: Missing source file: $src" -ForegroundColor Red
        exit 1
    }
}

Write-Host ""
Write-Host "=== Building: Eval Incarnate ===" -ForegroundColor Cyan
Write-Host ""

# Build the full paths for pandoc
$SourcePaths = $Sources | ForEach-Object { Join-Path $BookDir $_ }
$MetadataPath = Join-Path $BookDir "metadata.yml"

# --- EPUB ---
if ($Format -eq "epub" -or $Format -eq "both") {
    $EpubOut = Join-Path $OutputDir "Eval-Incarnate-A-Builders-Curriculum.epub"
    Write-Host "Building EPUB..." -ForegroundColor Green

    $pandocArgs = @(
        "--metadata-file=$MetadataPath"
        "--toc"
        "--toc-depth=2"
        "--split-level=1"
        "--standalone"
        "--shift-heading-level-by=0"
        "-o", $EpubOut
    ) + $SourcePaths

    & pandoc @pandocArgs

    if ($LASTEXITCODE -eq 0) {
        $size = (Get-Item $EpubOut).Length / 1KB
        Write-Host "  EPUB created: $EpubOut ($([math]::Round($size))KB)" -ForegroundColor Green
    } else {
        Write-Host "  EPUB build failed!" -ForegroundColor Red
    }
}

# --- PDF ---
if ($Format -eq "pdf" -or $Format -eq "both") {
    $PdfOut = Join-Path $OutputDir "Eval-Incarnate-A-Builders-Curriculum.pdf"
    Write-Host "Building PDF..." -ForegroundColor Green

    # Check for LaTeX
    $hasLatex = (Get-Command xelatex -ErrorAction SilentlyContinue) -or
                (Get-Command pdflatex -ErrorAction SilentlyContinue)

    if (-not $hasLatex) {
        Write-Host "  WARNING: No LaTeX distribution found. PDF requires LaTeX." -ForegroundColor Yellow
        Write-Host "  Install with: winget install MiKTeX.MiKTeX" -ForegroundColor Yellow
        Write-Host "  Or: choco install miktex" -ForegroundColor Yellow
        Write-Host "  Skipping PDF build." -ForegroundColor Yellow
    } else {
        # Determine PDF engine
        $pdfEngine = if (Get-Command xelatex -ErrorAction SilentlyContinue) { "xelatex" } else { "pdflatex" }

        $pandocArgs = @(
            "--metadata-file=$MetadataPath"
            "--toc"
            "--toc-depth=2"
            "--pdf-engine=$pdfEngine"
            "--standalone"
            "--shift-heading-level-by=0"
            "-V", "documentclass=report"
            "-V", "geometry:margin=1in"
            "-V", "fontsize=11pt"
            "-V", "linestretch=1.15"
            "-V", "colorlinks=true"
            "-V", "linkcolor=NavyBlue"
            "-V", "urlcolor=NavyBlue"
            "-o", $PdfOut
        ) + $SourcePaths

        & pandoc @pandocArgs

        if ($LASTEXITCODE -eq 0) {
            $size = (Get-Item $PdfOut).Length / 1KB
            Write-Host "  PDF created: $PdfOut ($([math]::Round($size))KB)" -ForegroundColor Green
        } else {
            Write-Host "  PDF build failed! (LaTeX errors are common with complex tables)" -ForegroundColor Red
            Write-Host "  Try EPUB instead: .\build-book.ps1 -Format epub" -ForegroundColor Yellow
        }
    }
}

# --- HTML (standalone, print-to-PDF friendly) ---
if ($Format -eq "html" -or $Format -eq "all") {
    $HtmlOut = Join-Path $OutputDir "Eval-Incarnate-A-Builders-Curriculum.html"
    Write-Host "Building HTML..." -ForegroundColor Green

    $pandocArgs = @(
        "--metadata-file=$MetadataPath"
        "--toc"
        "--toc-depth=2"
        "--standalone"
        "--embed-resources"
        "--shift-heading-level-by=0"
        "-o", $HtmlOut
    ) + $SourcePaths

    & pandoc @pandocArgs

    if ($LASTEXITCODE -eq 0) {
        $size = (Get-Item $HtmlOut).Length / 1KB
        Write-Host "  HTML created: $HtmlOut ($([math]::Round($size))KB)" -ForegroundColor Green
        Write-Host "  Tip: Open in a browser and use Print > Save as PDF" -ForegroundColor DarkGray
    } else {
        Write-Host "  HTML build failed!" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "=== Done ===" -ForegroundColor Cyan
Write-Host "Output in: $OutputDir" -ForegroundColor White
Write-Host ""
