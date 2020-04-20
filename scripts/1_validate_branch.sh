#!/usr/bin/env bash

set -e

BRANCH=$1

# get scripts directory path
SCRIPTS_DIR=$(dirname "${BASH_SOURCE[0]}")
SCRIPTS_DIR=$(readlink -f "${SCRIPTS_DIR}")

# 0. go to logs directory
cd "${HOLBA_LOGS_DIR}/EmbExp-Logs"

# 1. ensure that logs repository has no changes
"${SCRIPTS_DIR}/0_ensure_clean_state.sh"

# 2. checkout BRANCH
git checkout "${BRANCH}"

# 3. clear experiment runs
echo "Number of experiment runs before clearing: "
find arm8 -name run.* | wc -l
echo "Clearing now..."
find arm8 -name run.* -type d -exec rm -rf {} \;
echo "Number of experiment runs after clearing: "
find arm8 -name run.* | wc -l

# 4. spawn a terminal to connect to a board, ask the user to say when the connection to the board is established
gnome-terminal -- bash -c "\"${HOLBA_DIR}/src/tools/scamv/examples/scripts/2-connect.sh\" rpi3"
echo "Is the connection to the board successfully established?"
select yn in "Yes" "No"; do
  case $yn in
    Yes ) break;;
    No )  git checkout -- .; exit -1;;
  esac
done

# 5. run experiments using scam-v script
"${HOLBA_DIR}/src/tools/scamv/examples/scripts/3-run.sh" arm8/exps2

# 6. print information
echo "Experiment rerunning has finished, please terminate the connection to the board in the new terminal window and check the results manually now using \"git diff\""

echo "Number of experiment runs after rerunning: "
find arm8 -name run.* | wc -l

