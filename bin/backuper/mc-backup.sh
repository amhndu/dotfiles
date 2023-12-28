#!/bin/bash

set -o pipefail
set -e

echo "[copying mc world from mc server]"

rsync -az mc:/home/ubuntu/mc/ /home/amish/games/Minecraft/kc_end/mc --delete-after

echo "[starting mc backup...]"

parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )

source "$parent_path/creds.sh"

export RESTIC_REPOSITORY="sftp:saber:/media/data/restic/mc"

if [[ -z "$RESTIC_PASSWORD" ]]; then
    echo "error: expecting RESTIC_PASSWORD to be set"
fi

restic backup --iexclude /home/amish/bin/backuper/excludes.txt /home/amish/games/Minecraft/
restic forget --keep-within-daily 15d --keep-within-weekly 100y
restic prune

restic snapshots

echo "[finished mc backup]"
