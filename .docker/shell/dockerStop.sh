#!/bin/bash
export XDEBUG_HOST=""

if [ "$(uname)" == "Darwin" ]; then
  # Do something under Mac OS X platform
  echo "Stopping Wordpress Docker (MacOSX)"

  # Import env file exports
  if [[ -f "$FILE_PATH/../.env" ]]; then
    set -o allexport
    source .env
    set +o allexport
  fi

  # Gather User & Group ID
  if [[ -z "$HOST_USER_ID" ]]; then
    HOST_USER_ID=$(id -u) # User ID
    export HOST_USER_ID
  fi

  if [[ -z "$HOST_USER_GID" ]]; then
    HOST_USER_GID=$(id -g) # Group ID
    export HOST_USER_GID
  fi

  # Spinnup docker compose
  docker-compose -f .docker/docker-compose.yml -f .docker/docker-compose-mac.yml down --remove-orphans --volumes
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" -o "$(expr substr $(uname -s) 1 10)" == "MINGW64_NT" ]; then
  # Do something under GNU/Linux platform
  echo "Stopping TCMS Docker (Linux)"

  # Import env file exports
  if [[ -f "$FILE_PATH/../.env" ]]; then
    set -o allexport
    source .env
    set +o allexport
  fi

  # Gather User & Group ID
  if [[ -z "$HOST_USER_ID" ]]; then
    HOST_USER_ID=$(id -u) # User ID
    export HOST_USER_ID
  fi

  if [[ -z "$HOST_USER_GID" ]]; then
    HOST_USER_GID=$(id -g) # Group ID
    export HOST_USER_GID
  fi

  docker-compose -f .docker/docker-compose.yml -f .docker/docker-compose-default.yml down --remove-orphans --volumes
fi
