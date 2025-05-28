#!/usr/bin/env bash

_fj_confirm() {
  msg="$1"
  abort_msg="${2:-Aborting.}"
  _fj_log "$msg. Continue? [y/N] "
  read
  if [[ "$REPLY" != "y" ]]; then
    _fj_log "$abort_msg"
    exit
  fi
}
