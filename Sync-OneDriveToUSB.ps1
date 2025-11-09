<# 
Sync entire OneDrive "OneDrive - Atlantic TU" to D:\College (incremental).
- Skips hidden/system + locked files (so OneDrive temp files don't block).
- Copies new/changed files only; keeps existing files on USB by default.
#>

# ========= YOUR SETTINGS =========
$source = "C:\Users\burke\OneDrive - Atlantic TU"
$dest   = "D:\College"

# File/dir excludes (you can add more later)
$excludeFiles = @(
  "desktop.ini",
  "Thumbs.db",
  "*.tmp",
  "~$*",                                 # Office lock files
  ".849C9593-D756-4E56-8D6E-42412F2A707B*"  # OneDrive GUID file(s)
)
$excludeDirs  = @()  # e.g., ".git","node_modules","Temp"

# Behavior
$skipLocked      = $true     # skip files in use
$useMirrorDelete = $false    # mirror deletions if you set this to $true
# =================================

Write-Host "== Syncing OneDrive -> USB ==" -ForegroundColor Cyan

if (-not (Test-Path -LiteralPath $source)) { Write-Host "Source not found: $source" -ForegroundColor Red; exit 2 }
if (-not (Test-Path -LiteralPath $dest))   { New-Item -ItemType Directory -Path $dest | Out-Null }

# --- Build robocopy arguments ---
$robocopyArgs = @(
  "`"$source`"", "`"$dest`"",
  "/E",
  "/XO",
  "/COPY:DAT", "/DCOPY:DAT",
  "/MT:8",
  "/FFT",
  "/XJ",
  "/TEE",
  "/NFL", "/NDL", "/NP",
  "/XA:SH"          # <== skip Hidden & System files (catches the GUID file)
)

# Retry policy
if ($skipLocked) { $robocopyArgs += "/R:0", "/W:0" } else { $robocopyArgs += "/R:3", "/W:5" }

# Excludes
foreach ($p in $excludeFiles) { $robocopyArgs += "/XF", $p }
foreach ($p in $excludeDirs)  { $robocopyArgs += "/XD", $p }

if ($useMirrorDelete) { $robocopyArgs += "/MIR" }

# Logging
$logDir = Join-Path $env:USERPROFILE "Documents\BackupLogs"
if (-not (Test-Path $logDir)) { New-Item -ItemType Directory -Path $logDir | Out-Null }
$logFile = Join-Path $logDir ("onedrive_to_usb_" + (Get-Date -Format "yyyy-MM-dd_HH-mm-ss") + ".log")
$robocopyArgs += "/LOG:`"$logFile`""

# Show final args (sanity check)
Write-Host "Robocopy args: $($robocopyArgs -join ' ')" -ForegroundColor DarkCyan
Write-Host "Source:      $source"
Write-Host "Destination: $dest"
Write-Host ""

# Run
$exe = "$env:SystemRoot\System32\robocopy.exe"
& $exe $robocopyArgs
$code = $LASTEXITCODE

# Treat small skips/extras as success
if ($code -le 3) {
  Write-Host "Backup completed (locked/hidden files were skipped). Log: $logFile" -ForegroundColor Green
  exit 0
} else {
  Write-Host "Backup finished with code $code. Check the log: $logFile" -ForegroundColor Yellow
  exit $code
}
