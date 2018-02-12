#!/usr/bin/env bash

# reset permissions
UNAME_OUTPUT="$(uname -s)"

if [ "$UNAME_OUTPUT" == "Darwin" ]; then
    echo "Darwin"
else
    echo "Linux"
fi