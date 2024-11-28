# Set strict error handling (similar to set -o pipefail and set -e)
$ErrorActionPreference = "Stop"

Write-Host "[starting windows system backup...]"

# Get the script location (similar to dirname)
$parentPath = $PSScriptRoot

# Load credentials file (assuming creds.ps1 is in the same directory)
. "$parentPath\creds.ps1"

# Set Restic repository (similar to export)
$env:RESTIC_REPOSITORY = "sftp:saber:/media/data/restic/winnavi"

# Check if RESTIC_PASSWORD is set (similar to `[[ -z "$RESTIC_PASSWORD" ]]`)
if (-not $env:RESTIC_PASSWORD) {
    Write-Error "error: expecting RESTIC_PASSWORD environment variable to be set"
    Exit 1
}

# Backup files (using Restic.exe)
restic backup --files-from "$parentPath\win-includes.txt" --exclude "$parentPath\excludes.txt"

# Prune old backups
restic forget --keep-within daily 15 -keep-within weekly 100y
restic prune

# List snapshots
restic snapshots

Write-Host "[finished system backup]"