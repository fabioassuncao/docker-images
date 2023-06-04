#!/usr/bin/env bash

# if there is a env file, source it
if [ -f "./.env" ]; then
   source ./.env
# source example else
else
   source ./.env.example
fi

# for returning later to the main directory
ROOT_DIRECTORY=`pwd`

# function for building images
function build_repository {
    REPOSITORY=$1
    TAG=$2

    echo $'\n\n'"# Building $NAMESPACE/$REPOSITORY:$TAG"$'\n'
    cd $ROOT_DIRECTORY/$REPOSITORY/$TAG

    if [ $USE_CACHE == true ]; then
        docker build -t $NAMESPACE/$REPOSITORY:$TAG .
    fi

    if [ $USE_CACHE == false ]; then
        docker build --no-cache=true -t $NAMESPACE/$REPOSITORY:$TAG .
    fi

    # create the latest tag
    echo $'\n\n'"# Aliasing $LATEST as 'latest'"$'\n'
    docker tag $NAMESPACE/$REPOSITORY:$LATEST $NAMESPACE/$REPOSITORY:latest
}

# function for publishing images
function publish_repository {
    REPOSITORY=$1
    TAG=$2

    echo $'\n\n'"# Publishing $NAMESPACE/$REPOSITORY:$TAG"$'\n'
    docker push $NAMESPACE/$REPOSITORY:$TAG

    # create the latest tag
    echo $'\n\n'"# Publishing $NAMESPACE/$REPOSITORY:latest (from $LATEST)"$'\n'
    docker push $NAMESPACE/$REPOSITORY:latest
}

# Run git diff in the correct directory
cd $GITHUB_WORKSPACE

CHANGED_FILES=$(git diff --name-only HEAD~1..HEAD 2> /dev/null || true)

for file in $CHANGED_FILES; do
    REPOSITORY=$(echo $file | cut -f1 -d '/')
    TAG=$(echo $file | cut -f2 -d '/')

    # Ensure the Dockerfile was changed
    if [[ $file == *Dockerfile* ]]; then
      build_repository $REPOSITORY $TAG

      if [ $PUBLISH == true ]; then
        publish_repository $REPOSITORY $TAG
      fi
    fi
done
