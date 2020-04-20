#!/usr/bin/env bash

set -e

EXPGENRUN_ID_PARAM=$1

# get scripts directory path
SCRIPTS_DIR=$(dirname "${BASH_SOURCE[0]}")
SCRIPTS_DIR=$(readlink -f "${SCRIPTS_DIR}")

# 0. go to scamv examples directory
cd "${HOLBA_DIR}/src/tools/scamv/examples"

# 1. ensure that logs repository has no changes
"${SCRIPTS_DIR}/0_ensure_clean_state.sh"

# 2. spawn experiment generation
gnome-terminal -- bash -c "\"./scripts/1-gen.sh\" reprod \"${EXPGENRUN_ID_PARAM}\""
echo "Is the experiment generation running?"
select yn in "Yes" "No"; do
  case $yn in
    Yes ) break;;
    No )  exit -1;;
  esac
done

# 3. spawn a terminal to connect to a board, ask the user to say when the connection to the board is established
gnome-terminal -- bash -c "\"./scripts/2-connect.sh\" rpi3"
echo "Is the connection to the board successfully established?"
select yn in "Yes" "No"; do
  case $yn in
    Yes ) break;;
    No )  echo "Please terminate the experiment generation and restart with cleaning the logs repository state (removing the local reprod branches).";exit -1;;
  esac
done

# 4. run experiments using scam-v script
"./scripts/3-run.sh" arm8/exps2

# 5. print information
echo "Experiment running has finished, please check terminate the connection to the board in the new terminal window, make sure that the experiment generation terminated already and check the results"


