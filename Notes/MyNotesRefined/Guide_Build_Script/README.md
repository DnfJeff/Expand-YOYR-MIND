# Guide Build Script

Pandoc-based build pipeline for compiling **Eval Incarnate: A Builder's Curriculum** into EPUB and HTML.

## Files

| File | Purpose |
|------|---------|
| `build-book.ps1` | PowerShell build script — runs Pandoc to produce EPUB/HTML |
| `metadata.yml` | Book metadata (title, author, formatting options) |
| `Foreword.md` | Foreword source |
| `Introduction.md` | Introduction source |
| `Part_1.md`–`Part_5.md` | Manuscript chapters |

## Usage

```powershell
.\build-book.ps1
```

Output lands in [Mayberry-A-Moral-Mecca/output/](../../../../Mayberry-A-Moral-Mecca/output/).
