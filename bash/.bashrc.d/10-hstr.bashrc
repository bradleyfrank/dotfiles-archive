#!/bin/bash

if type hstr &> /dev/null; then
  # Settings for hstr
  bind "'\C-r': '\C-a hh -- \C-j'"
  export HH_CONFIG=hicolor
fi