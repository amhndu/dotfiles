#!/bin/bash

parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
cd "$parent_path"

./backuper/restic-backup.sh
./backuper/mc-backup.sh
