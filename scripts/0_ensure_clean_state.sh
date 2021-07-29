#!/usr/bin/env bash

set -e

# 0. go to logs directory
cd "${HOLBA_LOGS_DIR}/EmbExp-Logs"

# 1. ensure that logs repository has no data
if [[ -d "data" ]]; then
  echo "The logs repository contains data, do you want to remove the data?"
  select yn in "Yes" "No"; do
    case $yn in
      Yes ) rm -rf data; break;;
      No )  echo "logs repository contains data, cannot go ahead"; exit -1;;
    esac
  done
fi

# 2. ensure that logs repository has no changes
if [[ ! -z "$(git status --porcelain)" ]]; then
  echo "The logs repository is not clean, do you want to discard all changes?"
  select yn in "Yes" "No"; do
    case $yn in
      Yes ) git clean -xfd; git checkout -- .; git checkout master; git clean -fdx; break;;
      No )  echo "logs repository is not clean"; break;;
     esac
  done
fi


