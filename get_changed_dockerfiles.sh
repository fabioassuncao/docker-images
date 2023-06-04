#!/bin/bash

# Get a list of changed files
CHANGED_FILES=$(git diff --name-only HEAD^ HEAD)

# Iterate over all changed files
for FILE in $CHANGED_FILES
do
  # Check if the file is a Dockerfile
  if [[ $FILE == *"Dockerfile"* ]]
  then
    # Print the directory of the Dockerfile
    echo $(dirname $FILE)
  fi
done
