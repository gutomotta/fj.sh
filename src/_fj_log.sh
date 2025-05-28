#!/usr/bin/env bash

_fj_log() {
  msg="$@"


  if [ $FJ_LOG_INDENT -gt 0 ]
  then
      for ((i = 0; i < FJ_LOG_INDENT; i++))
      do
        msg=" $msg"
      done
  fi

  printf "%b" "$msg"

  # If the last character of message is white space then do not add new line:
  if [[ "${msg: -1}" != " " ]]
  then
    echo
  fi
}
