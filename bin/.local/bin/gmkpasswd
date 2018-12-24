#!/bin/bash

set -eu

DELIM="-"
NUM=4
DICT="$HOME/.local/share/dict/words"

usage() {
  echo "Generates a password <number> words long, separated by <deliminator>."
  echo "Usage: gmkpasswd [-h|--help] | [number] [deliminator]"
  echo "  number:       any whole number > 0; default is 4"
  echo "  deliminator:  ASCII deliminator; default is '-'"
}

validate_arg1() {
  if [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]; then
    usage
    exit 0
  elif [[ ! "$1" =~ ^[0-9]+$ ]]; then
    echo "Error: not a valid whole number."
    exit 1
  else
    NUM="$1"
  fi
}

validate_arg2() {
  if [[ "$1" == *[![:ascii:]]* ]]; then
    echo "Error: unsupported deliminator."
    exit 1
  else
    DELIM="$1"
  fi
} 

case "$#" in
  1) validate_arg1 "$1" ;;
  2) validate_arg1 "$1" ; validate_arg2 "$2" ;;
esac

if [[ ! -e "$DICT" ]]; then
  DICT="/usr/share/dict/words"
fi

if type shuf >/dev/null 2>&1; then
  _shuf="shuf"
elif type gshuf >/dev/null 2>&1; then
  _shuf="gshuf"
else
  echo "Error: shuf not found."
  exit 1
fi

"$_shuf" --random-source=/dev/random -n "$NUM" "$DICT" | tr '[:upper:]' '[:lower:]' | sed -e ':a' -e 'N' -e '$!ba' -e "s/\\n/$DELIM/g"
