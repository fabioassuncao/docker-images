#!/usr/bin/env bash

set -e

# If there is an env file, source it
if [ -f "./.env" ]; then
   source ./.env
# Source the example file otherwise
else
   source ./.env.example
fi

# Enabled repositories for the build
REPOSITORIES=$1

# Enable all repositories if none specified
if [[ -z $REPOSITORIES ]]; then
    REPOSITORIES=($ALL_REPOSITORIES)
fi

# Root directory
ROOT_DIRECTORY=$(pwd)

# Function for building images
function build_repository {
  DOCKERFILE_PATH=$1
  # Read repository configuration
  source "$DOCKERFILE_PATH/buildvars"

  # Build all enabled versions
  for TAG in $TAGS; do
    # Some verbose
    echo $'\n\n'"# Building $NAMESPACE/$REPOSITORY:$TAG"$'\n'
    (cd "$DOCKERFILE_PATH" && \
    if [ "$USE_CACHE" == true ]; then
      # Build using cache
      docker build -t "$NAMESPACE/$REPOSITORY:$TAG" .
    else
      docker build --no-cache=true -t "$NAMESPACE/$REPOSITORY:$TAG" .
    fi)
  done

  # Create the latest tag
  echo $'\n\n'"# Aliasing $LATEST as 'latest'"$'\n'
  docker tag "$NAMESPACE/$REPOSITORY:$LATEST" "$NAMESPACE/$REPOSITORY:latest"
}

# Function for publishing images
function publish_repository {
  DOCKERFILE_PATH=$1
  # Read repository configuration
  source "$DOCKERFILE_PATH/buildvars"

  # Publish all enabled versions
  for TAG in $TAGS; do
    # Some verbose
    echo $'\n\n'"# Publishing $NAMESPACE/$REPOSITORY:$TAG"$'\n'
    # Publish
    docker push "$NAMESPACE/$REPOSITORY:$TAG"
  done

  # Create the latest tag
  echo $'\n\n'"# Publishing $NAMESPACE/$REPOSITORY:latest (from $LATEST)"$'\n'
  docker push "$NAMESPACE/$REPOSITORY:latest"
}

# For each enabled repository
for REPOSITORY in "${REPOSITORIES[@]}"; do
  # Get the Dockerfile path for this repository
  DOCKERFILE_PATHS=$(grep "$REPOSITORY" changed_dockerfiles.txt)

  # Check if the Dockerfile path is not empty
  for DOCKERFILE_PATH in $DOCKERFILE_PATHS; do
    if [[ -n $DOCKERFILE_PATH ]]; then
      # Build the repository
      build_repository "$DOCKERFILE_PATH"

      # If publishing is enabled
      if [ "$PUBLISH" == true ]; then
        # Push the built image
        publish_repository "$DOCKERFILE_PATH"
      fi
    fi
  done
done
