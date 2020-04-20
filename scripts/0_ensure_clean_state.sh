#!/usr/bin/env bash

set -e

# 0. go to logs directory
cd "${HOLBA_LOGS_DIR}/EmbExp-Logs"

# 1. ensure that logs repository has no changes
if [[ ! -z "$(git status --porcelain)" ]]; then
  echo "The logs repository is not clean, do you want to discard all changes?"
  select yn in "Yes" "No"; do
    case $yn in
      Yes ) git clean -xfd; git checkout -- .; break;;
      No )  echo "logs repository is not clean, cannot go ahead"; exit -1;;
    esac
  done
fi
git checkout master
git clean -fdx

# 2. get rid of branches that may have been created when reproducing experiments
REPROD_BRANCHES=`git branch | grep -E 'reprod_.*' | cat`
if [[ ! -z "${REPROD_BRANCHES}" ]]; then
  echo "Do you want to delete all reproduce branches?"
  select yn in "Yes" "No"; do
    case $yn in
      Yes ) git branch -D "${REPROD_BRANCHES}"; break;;
      No )  break;;
    esac
  done
fi

