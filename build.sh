#!/usr/bin/env bash

# If there is an env file, source it
if [ -f "./.env" ]; then
   source ./.env
# Source the example otherwise
else
   source ./.env.example
fi

# Enabled repositories for the build
REPOSITORIES=$1

# Enable all repositories if any are specified
if [[ -z $REPOSITORIES ]]; then
    REPOSITORIES=$ALL_REPOSITORIES
fi

# For returning later to the main directory
ROOT_DIRECTORY=`pwd`

# Function for building images
function build_repository {
    # Read repository configuration
    source $ROOT_DIRECTORY/$REPOSITORY/buildvars

    # Build all enabled versions
    for TAG in $TAGS; do
      # Check if any file has been modified in the directory
      if git diff --quiet HEAD^ HEAD -- $REPOSITORY/$TAG; then
        echo "$REPOSITORY/$TAG has not changed. Skipping build."
        continue
      fi

      # Some verbosity
      echo $'\n\n'"# Building $NAMESPACE/$REPOSITORY:$TAG"$'\n'
      cd $ROOT_DIRECTORY/$REPOSITORY/$TAG

      if [ $USE_CACHE == true ]; then
        # Build using cache
        docker build -t $NAMESPACE/$REPOSITORY:$TAG .
      fi

      if [ $USE_CACHE == false ]; then
        docker build --no-cache=true -t $NAMESPACE/$REPOSITORY:$TAG .
      fi

      # If this tag is the latest, create the 'latest' tag
      if [[ "$TAG" == "$LATEST" ]]; then
        echo $'\n\n'"# Aliasing $LATEST as 'latest'"$'\n'
        docker tag $NAMESPACE/$REPOSITORY:$LATEST $NAMESPACE/$REPOSITORY:latest
      fi
    done
}

# Function for publishing images
function publish_repository {
    # Read repository configuration
    source $ROOT_DIRECTORY/$REPOSITORY/buildvars

    # Publish all enabled versions
    for TAG in $TAGS; do
      # Check if any file has been modified in the directory
      if git diff --quiet HEAD^ HEAD -- $REPOSITORY/$TAG; then
        echo "$REPOSITORY/$TAG has not changed. Skipping push."
        continue
      fi

      # Some verbosity
      echo $'\n\n'"# Publishing $NAMESPACE/$REPOSITORY:$TAG"$'\n'
      # Publish
      docker push $NAMESPACE/$REPOSITORY:$TAG

      # If this tag is the latest, push the 'latest' tag
      if [[ "$TAG" == "$LATEST" ]]; then
        echo $'\n\n'"# Publishing $NAMESPACE/$REPOSITORY:latest (from $LATEST)"$'\n'
        docker push $NAMESPACE/$REPOSITORY:latest
      fi
    done
}

# Array to store the images that need to be built and published
images_to_process=()

# For each enabled repository
for REPOSITORY in $REPOSITORIES; do
  # Read repository configuration
  source $ROOT_DIRECTORY/$REPOSITORY/buildvars

  # Check all tags to determine which need to be processed
  for TAG in $TAGS; do
    # Check if any file has been modified in the directory
    if git diff --quiet HEAD^ HEAD -- $REPOSITORY/$TAG; then
      echo "$REPOSITORY/$TAG has not changed."
    else
      images_to_process+=("$REPOSITORY:$TAG")
    fi
  done
done

# Process the images stored in the array
for image in "${images_to_process[@]}"; do
  REPOSITORY=$(echo "$image" | cut -d':' -f1)
  TAG=$(echo "$image" | cut -d':' -f2)

  # Build the image
  echo $'\n\n'"# Building $NAMESPACE/$image"$'\n'
  cd $ROOT_DIRECTORY/$REPOSITORY/$TAG
  if [ $USE_CACHE == true ]; then
    docker build -t $NAMESPACE/$image .
  else
    docker build --no-cache=true -t $NAMESPACE/$image .
  fi

  # If this tag is the latest, create the 'latest' tag
  if [[ "$TAG" == "$LATEST" ]]; then
    echo $'\n\n'"# Aliasing $LATEST as 'latest'"$'\n'
    docker tag $NAMESPACE/$image $NAMESPACE/$REPOSITORY:latest
  fi

  # If publishing is enabled, push the image
  if [ $PUBLISH == true ]; then
    echo $'\n\n'"# Publishing $NAMESPACE/$image"$'\n'
    docker push $NAMESPACE/$image

    # If this tag is the latest, push the 'latest' tag as well
    if [[ "$TAG" == "$LATEST" ]]; then
      echo $'\n\n'"# Publishing $NAMESPACE/$REPOSITORY:latest (from $LATEST)"$'\n'
      docker push $NAMESPACE/$REPOSITORY:latest
    fi
  fi
done