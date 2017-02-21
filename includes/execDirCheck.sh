#!/bin/bash

EXECUTIONDIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then EXECUTIONDIR="$PWD"; fi

echo -e "${EXECUTIONDIR}"
