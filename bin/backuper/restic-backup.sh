#!/bin/bash

set -o pipefail
set -e

echo "[starting backup...]"

source creds.sh

if [[ -z "$RESTIC_PASSWORD" ]]; then
    echo "error: expecting RESTIC_PASSWORD to be set"
fi

if [[ -z "$RESTIC_REPOSITORY" ]]; then
    echo "error: expecting RESTIC_REPOSITORY to be set"
fi

#restic backup --files-from /home/amish/bin/backuper/includes.txt --iexclude /home/amish/bin/backuper/excludes.txt
