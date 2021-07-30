#!/usr/bin/env bash

set -e

EXTRA_OPTIONS=${@:1}

SCAMV_SCRIPTS_DIR="${HOLBA_DIR}/src/tools/scamv/examples/scripts"

"${SCAMV_SCRIPTS_DIR}/4-status.sh" ${EXTRA_OPTIONS}


