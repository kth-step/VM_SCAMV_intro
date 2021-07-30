#!/usr/bin/env bash

set -e

EXPGENRUN_ID_PARAM=$1

# get scripts directory path
SCRIPTS_DIR=$(dirname "${BASH_SOURCE[0]}")
SCRIPTS_DIR=$(readlink -f "${SCRIPTS_DIR}")

SCAMV_SCRIPTS_DIR="${HOLBA_DIR}/src/tools/scamv/examples/scripts"

# 1. ensure that logs repository has no data
"${SCRIPTS_DIR}/0_ensure_clean_state.sh"

# 2. spawn experiment generation
gnome-terminal -- bash -i -c "\"${SCAMV_SCRIPTS_DIR}/1-gen.sh\" reprod \"${EXPGENRUN_ID_PARAM}\"; sleep 2s" > /dev/null &
echo "=================================================================="
echo "Wait until SCAM-V outputs are continuously running in the new terminal."
echo "Is the experiment generation running?"
select yn in "Yes" "No"; do
  case $yn in
    Yes ) break;;
    No )  exit -1;;
  esac
done

# 3. spawn a terminal to connect to a board, ask the user to say when the connection to the board is established
gnome-terminal -- bash -i -c "\"${SCAMV_SCRIPTS_DIR}/2-connect.sh\" rpi3; sleep 2s" > /dev/null &
echo "=================================================================="
echo "Wait until the new terminal shows the line \"===    finished starting    ===\"."
echo "Is the connection to the board successfully established?"
select yn in "Yes" "No"; do
  case $yn in
    Yes ) break;;
    No )  echo "Please terminate the experiment generation and restart with cleaning the logs repository state (removing the local reprod branches).";exit -1;;
  esac
done

# 4. run experiments using scam-v script
"${SCAMV_SCRIPTS_DIR}/3-run.sh"

# 5. print information
echo ""
echo "=================================================================="
echo "Experiment running has finished, please terminate the connection to the board in the new terminal window, make sure that the experiment generation terminated already and check the results"


