#!/bin/bash

# Builds JSX source files in inst/htmlwidgets-src. Pass "-w" to watch
# (i.e. continuously build).

if ! which jsx > /dev/null; then
  echo 'JSX is not installed; please execute "npm install -g react-tools" (may require root)'
  exit 1
fi

jsx $@ inst/htmlwidgets-src inst/htmlwidgets
