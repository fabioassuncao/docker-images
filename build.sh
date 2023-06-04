#!/usr/bin/env bash

# if there is a env file, source it
if [ -f "./.env" ]; then
   source ./.env
# source example else
else
   source ./.env.example
fi

# enabled repositories for the build
REPOSITORIES=$1

# Get changed files as second argument
changed_files=($2)

# enable all repositories if any specified
if [[ -z $REPOSITORIES ]]; then
    REPOSITORIES=$ALL_REPOSITORIES
fi

# for returning later to the main directory
ROOT_DIRECTORY=`pwd`

# function for building images
function build_repository {
    # read repository configuration
    source $ROOT_DIRECTORY/$REPOSITORY/buildvars

    # build all enabled versions
    for TAG in $TAGS; do
        # Check if this TAG has changed
        if [[ " ${changed_files[@]} " =~ "$REPOSITORY/$TAG" ]]; then
          # If a Dockerfile in this TAG has changed, then build it

          # some verbose
          echo $'\n\n'"# Building $NAMESPACE/$REPOSITORY:$TAG"$'\n'
          cd $ROOT_DIRECTORY/$REPOSITORY/$TAG

          if [ $USE_CACHE == true ]; then
            # build using cache
            docker build -t $NAMESPACE/$REPOSITORY:$TAG .
          fi

          if [ $USE_CACHE == false ]; then
            docker build --no-cache=true -t $NAMESPACE/$REPOSITORY:$TAG .
          fi
        fi
    done

    # create the latest tag
    echo $'\n\n'"# Aliasing $LATEST as 'latest'"$'\n'
    docker tag $NAMESPACE/$REPOSITORY:$LATEST $NAMESPACE/$REPOSITORY:latest
}

# function for publishing images
function publish_repository {
    # read repository configuration
    source $ROOT_DIRECTORY/$REPOSITORY/buildvars

    # publish all enabled versions
    for TAG in $TAGS; do
        # Check if this TAG has changed
        if [[ " ${changed_files[@]} " =~ "$REPOSITORY/$TAG" ]]; then
          # If a Dockerfile in this TAG has changed, then publish it

          # some verbose
          echo $'\n\n'"# Publishing $NAMESPACE/$REPOSITORY:$TAG"$'\n'
          # publish
          docker push $NAMESPACE/$REPOSITORY:$TAG
        fi
    done

    # create the latest tag
    echo $'\n\n'"# Publishing $NAMESPACE/$REPOSITORY:latest (from $LATEST)"$'\n'
    docker push $NAMESPACE/$REPOSITORY:latest
}

# for each enabled repository
for REPOSITORY in $REPOSITORIES; do
  # build and publish the repository if it has changed
  for file in "${changed_files[@]}"; do
    if [[ $file =~ ^$REPOSITORY/ ]]; then
      # If a file in this repository has changed, then build it
      build_repository $REPOSITORY

      # If publishing is enabled
      if [ $PUBLISH == true ]; then
        # Push the built image
        publish_repository $REPOSITORY
      fi
    fi
  done
done