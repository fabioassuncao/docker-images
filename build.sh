#!/usr/bin/env bash

# Define default architectures
DEFAULT_ARCHS="linux/arm64"
ARCHS="linux/amd64,linux/arm64,linux/arm/v8,linux/arm/v7,linux/arm/v6"

# Load environment variables
if [ -f "./.env" ]; then
   source ./.env
else
   source ./.env.example
fi

# Set repositories to process
REPOSITORIES=$1
if [[ -z $REPOSITORIES ]]; then
    REPOSITORIES=$ALL_REPOSITORIES
fi

# Save the root directory
ROOT_DIRECTORY=$(pwd)

# Function to build Docker images
function build_repository {
    local REPOSITORY=$1
    local TAGS=$2
    local NAMESPACE=$3
    local USE_CACHE=$4

    for TAG in $TAGS; do
      if git diff --quiet HEAD^ HEAD -- "$REPOSITORY/$TAG"; then
        echo "$REPOSITORY/$TAG has not changed. Skipping build."
        continue
      fi

      echo $'\n\n'"# Building $NAMESPACE/$REPOSITORY:$TAG"$'\n'
      cd "$ROOT_DIRECTORY/$REPOSITORY/$TAG"

      local BUILD_CMD="docker buildx build --platform $ARCHS -t $NAMESPACE/$REPOSITORY:$TAG ."
      if [ "$USE_CACHE" == "false" ]; then
        BUILD_CMD+=" --no-cache"
      fi

      if [ "$PUBLISH" == "true" ]; then
        BUILD_CMD+=" --push"
      fi

      eval $BUILD_CMD

      if [[ "$TAG" == "$LATEST" ]]; then
        echo $'\n\n'"# Tagging $NAMESPACE/$REPOSITORY:$TAG as 'latest'"$'\n'
        docker tag "$NAMESPACE/$REPOSITORY:$TAG" "$NAMESPACE/$REPOSITORY:latest"

        if [ "$PUBLISH" == "true" ]; then
          echo $'\n\n'"# Publishing $NAMESPACE/$REPOSITORY:latest"$'\n'
          docker push "$NAMESPACE/$REPOSITORY:latest"
        fi
      fi
    done
}

# Function to publish Docker images
function publish_repository {
    local REPOSITORY=$1
    local TAGS=$2
    local NAMESPACE=$3

    for TAG in $TAGS; do
      if git diff --quiet HEAD^ HEAD -- "$REPOSITORY/$TAG"; then
        echo "$REPOSITORY/$TAG has not changed. Skipping push."
        continue
      fi

      echo $'\n\n'"# Publishing $NAMESPACE/$REPOSITORY:$TAG"$'\n'
      docker push "$NAMESPACE/$REPOSITORY:$TAG"

      if [[ "$TAG" == "$LATEST" ]]; then
        echo $'\n\n'"# Publishing $NAMESPACE/$REPOSITORY:latest"$'\n'
        docker push "$NAMESPACE/$REPOSITORY:latest"
      fi
    done
}

# Array to store the images that need to be built and published
images_to_process=()

# Determine which repositories need to be processed
for REPOSITORY in $REPOSITORIES; do
  if [ -f "$ROOT_DIRECTORY/$REPOSITORY/buildvars" ]; then
    source "$ROOT_DIRECTORY/$REPOSITORY/buildvars"

    for TAG in $TAGS; do
      if ! git diff --quiet HEAD^ HEAD -- "$REPOSITORY/$TAG"; then
        images_to_process+=("$REPOSITORY:$TAG")
      else
        echo "$REPOSITORY/$TAG has not changed."
      fi
    done
  else
    echo "Configuration for $REPOSITORY not found. Skipping."
  fi
done

# Process the images that need to be built and published
for image in "${images_to_process[@]}"; do
  REPOSITORY=$(echo "$image" | cut -d':' -f1)
  TAG=$(echo "$image" | cut -d':' -f2)

  # Build the image
  build_repository "$REPOSITORY" "$TAG" "$NAMESPACE" "$USE_CACHE"

  # Publish the image if required
  if [ "$PUBLISH" == "true" ]; then
    publish_repository "$REPOSITORY" "$TAG" "$NAMESPACE"
  fi
done
