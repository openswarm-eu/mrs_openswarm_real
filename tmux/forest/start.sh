#!/bin/bash

# Absolute path to this script. /home/user/bin/foo.sh
SCRIPT=$(readlink -f $0)
# Absolute path this script is in. /home/user/bin
SCRIPTPATH=`dirname $SCRIPT`
cd "$SCRIPTPATH"

export TMUX_SESSION_NAME=real_drone
export TMUX_SOCKET_NAME=mrs
export TMUX_LOG_RECORDING=${TMUX_LOG_RECORDING:-1}

# location for storing the bag files
# * do not change unless you know what you are doing
MAIN_DIR=~/"bag_files"

# the project name
# * is used to define folder name in ~/$MAIN_DIR
export PROJECT_NAME="forest"

# get the iterator
ITERATOR_FILE="$MAIN_DIR/$PROJECT_NAME"/iterator.txt
if [ -e "$ITERATOR_FILE" ]
then
  ITERATOR=`cat "$ITERATOR_FILE"`
  ITERATOR=$(($ITERATOR+1))
else
  echo "iterator.txt does not exist, creating it"
  mkdir -p "$MAIN_DIR/$PROJECT_NAME"
  touch "$ITERATOR_FILE"
  ITERATOR="1"
fi
echo "$ITERATOR" > "$ITERATOR_FILE"

# create file for logging terminals' output
LOG_DIR="$MAIN_DIR/$PROJECT_NAME/"
SUFFIX=$(date +"%Y_%m_%d_%H_%M_%S")
SUBLOG_DIR="$LOG_DIR/"$ITERATOR"_"$SUFFIX""
TMUX_DIR="$SUBLOG_DIR/tmux"
mkdir -p "$SUBLOG_DIR"
if [ "$TMUX_LOG_RECORDING" = "1" ]; then
  mkdir -p "$TMUX_DIR"
fi

# link the "latest" folder to the recently created one
rm "$LOG_DIR/latest" > /dev/null 2>&1
ln -sf "$SUBLOG_DIR" "$LOG_DIR/latest"

# start tmuxinator
tmuxinator start -p ./session.yml

if [ "$TMUX_LOG_RECORDING" = "1" ]; then
  # log each pane output into tmux/<window_name>/pane_<idx>.log
  for _ in $(seq 1 50); do
    tmux -L $TMUX_SOCKET_NAME has-session -t $TMUX_SESSION_NAME > /dev/null 2>&1 && break
    sleep 0.1
  done

  for PANE_ID in $(tmux -L $TMUX_SOCKET_NAME list-panes -a -t $TMUX_SESSION_NAME -F "#{pane_id}"); do
    WINDOW_NAME=$(tmux -L $TMUX_SOCKET_NAME display-message -p -t "$PANE_ID" "#{window_name}")
    PANE_INDEX=$(tmux -L $TMUX_SOCKET_NAME display-message -p -t "$PANE_ID" "#{pane_index}")

    SAFE_WINDOW_NAME=$(echo "$WINDOW_NAME" | tr '[:space:]/' '__' | tr -cd '[:alnum:]_.-')
    [ -z "$SAFE_WINDOW_NAME" ] && SAFE_WINDOW_NAME="window"

    WINDOW_LOG_DIR="$TMUX_DIR/$SAFE_WINDOW_NAME"
    PANE_LOG_FILE="$WINDOW_LOG_DIR/pane_${PANE_INDEX}.log"

    mkdir -p "$WINDOW_LOG_DIR"
    tmux -L $TMUX_SOCKET_NAME pipe-pane -t "$PANE_ID"
    tmux -L $TMUX_SOCKET_NAME pipe-pane -t "$PANE_ID" "exec cat >> '$PANE_LOG_FILE'"
  done
fi

# if we are not in tmux
if [ -z $TMUX ]; then

  # just attach to the session
  tmux -L $TMUX_SOCKET_NAME a -t $TMUX_SESSION_NAME

# if we are in tmux
else

  # switch to the newly-started session
  tmux detach-client -E "tmux -L $TMUX_SOCKET_NAME a -t $TMUX_SESSION_NAME" 

fi
