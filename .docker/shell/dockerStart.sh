#!/bin/bash
DOCKER_REBUILD=()
SYSTEM_UNAME="$(uname -s)"
FILE_PATH=$(dirname "$0")

bash ./.docker/shell/init-wordpress.sh
exit

ask_for_rebuild() {
  echo -n "Do you wish to rebuild the containers? [yn] - [n]:"
  read -n 1 decision
  echo ""

  if [[ "$decision" == "y" ]]; then
    DOCKER_REBUILD+=(--build --force-recreate)
    docker system prune --all --volumes --force
  fi

}

COMPOSER_OVERRIDE=docker-compose.override.yml
DOCKER_OVERRIDE_COMMAND=()
if [[ -f "$COMPOSER_OVERRIDE" ]]; then
  DOCKER_OVERRIDE_COMMAND+=(-f "$COMPOSER_OVERRIDE")
fi

if [[ "$SYSTEM_UNAME" == "Darwin" ]]; then
  # Do something under Mac OS X platform
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

  echo "User: ${HOST_USER_ID} | Group: ${HOST_USER_GID}"

  # Create Env Variables
  echo "Get Host IP for XDEBUG..."
  if [[ -z "$XDEBUG_HOST" ]]; then
    XDEBUG_HOST="$(./.docker/shell/getLocalIp.sh)"
    export XDEBUG_HOST
    echo "HOST IP found: $XDEBUG_HOST"
  fi

  # TODO Install mutagen if not installed
  #brew install mutagen-io/mutagen/mutagen

  echo "Starting wordpress Docker (MacOSX)"
  # Create project which uses the mutagen.yml file to create the sync
  # mutagen project start

  # Start NFS
  bash ./.docker/shell/dockerOSX_NFS.sh
  # Ask for rebuild
  ask_for_rebuild

  export DOCKER_BUILDKIT=1

  # Spinnup docker compose
  docker-compose -f .docker/docker-compose.yml -f .docker/docker-compose-mac.yml "${DOCKER_OVERRIDE_COMMAND[@]}" up --remove-orphans --detach "${DOCKER_REBUILD[@]}"

elif [[ "$(expr substr $SYSTEM_UNAME 1 5)" == "Linux" ]] || [[ "$(expr substr $SYSTEM_UNAME 1 10)" == "MINGW64_NT" ]]; then

  # Import env file exports
  if [[ -f "$FILE_PATH/../.env" ]]; then
    set -o allexport
    source .env
    set +o allexport
  fi

  if [[ -z "$HOST_USER_ID" ]]; then
    HOST_USER_ID=$(id -u) # User ID
    export HOST_USER_ID
  fi

  if [[ -z "$HOST_USER_GID" ]]; then
    HOST_USER_GID=$(id -g) # Group ID
    export HOST_USER_GID
  fi

  echo "User: ${HOST_USER_ID} | Group: ${HOST_USER_GID}"

  # IS WLS?
  if grep -qEi "(Microsoft|WSL)" /proc/version &>/dev/null; then
    echo "Windows 10 WSL"
    WSL_IP=$(grep nameserver /etc/resolv.conf | cut -d ' ' -f2)
    export XDEBUG_HOST=$WSL_IP
  else
    echo "Any Linux"
    # Set env to basic if no xdebug host is set
    if [[ -z "$XDEBUG_HOST" ]]; then
      export XDEBUG_HOST=192.168.222.1
    fi

  fi

  # Do something under GNU/Linux platform
  export DOCKER_BUILDKIT=1
  echo "Starting TCMS Docker (Linux)"
  # Ask for rebuild
  ask_for_rebuild
  # Docker Compose
  docker-compose -f .docker/docker-compose.yml -f .docker/docker-compose-default.yml "${DOCKER_OVERRIDE_COMMAND[@]}" up --remove-orphans --detach "${DOCKER_REBUILD[@]}"

fi

bash ./.docker/shell/init-wordpress.sh

echo "Init Project Finished"

echo "Docker Log Output"
docker-compose logs --tail=10 --timestamps
