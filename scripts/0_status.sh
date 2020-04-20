#!/usr/bin/env bash

set -e

# 0. go to logs directory
cd "${HOLBA_LOGS_DIR}/EmbExp-Logs"

# 1. run the status script
./scripts/status.py


