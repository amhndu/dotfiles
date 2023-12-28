#!/bin/bash

set -o pipefail
set -e

echo "[starting system backup...]"

parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )

source "$parent_path/creds.sh"

export RESTIC_REPOSITORY="sftp:saber:/media/data/restic/navi"

if [[ -z "$RESTIC_PASSWORD" ]]; then
    echo "error: expecting RESTIC_PASSWORD to be set"
fi

restic backup --files-from /home/amish/bin/backuper/includes.txt --iexclude /home/amish/bin/backuper/excludes.txt
restic forget --keep-within-daily 15d --keep-within-weekly 100y
restic prune

restic snapshots

echo "[finished system backup]"
