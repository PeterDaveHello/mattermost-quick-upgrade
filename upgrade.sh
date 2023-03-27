#!/bin/sh

{

  # ColorEchoForShell
  # https://github.com/PeterDaveHello/ColorEchoForShell

  echoCyan() {
    echo "\\033[36m$*\\033[m"
  }

  echoRed() {
    echo "\\033[31m$*\\033[m"
  }

  set -ex

  error() {
    echoRed >&2 "$@"
    exit 1
  }

  for cmd in wget mktemp tar find systemctl cp rm chown xargs sort; do
    if ! command -v $cmd > /dev/null 2>&1; then
      error "command: $cmd not found!"
    fi
  done

  if [ "$(id -u)" != "0" ]; then
    error "Please give me root permission"
  fi

  echoCyan "Setting Mattermost version and install path"
  MATTERMOST_VERSION="${MATTERMOST_VERSION:-7.3.0}"
  INSTALL_PATH="${INSTALL_PATH:-/opt}"

  if ! [ -e "${INSTALL_PATH}/mattermost/bin/mattermost" ]; then
    error "${INSTALL_PATH} doesn't seem to be the right path!"
  fi

  echoCyan "Preparing working directory and install package"
  TMP="$(mktemp -d --suffix=-mattermost)"

  if ! cd "${TMP}"; then
    error "Change directory to ${TMP} failed"
  fi

  wget "https://releases.mattermost.com/$MATTERMOST_VERSION/mattermost-$MATTERMOST_VERSION-linux-amd64.tar.gz" -O "mattermost-linux-amd64.tar.gz"

  tar -xf mattermost-linux-amd64.tar.gz --transform='s,^[^/]\+,\0-upgrade,'

  chown -hR mattermost:mattermost ./mattermost-upgrade/

  echoCyan "Stopping Mattermost service"
  systemctl stop mattermost

  echoCyan "Making backup of current Mattermost files"
  cp -ra "${INSTALL_PATH}/mattermost/" "${INSTALL_PATH}/mattermost-back-$(date +'%F-%H-%M')/"

  if ! cd "${INSTALL_PATH}"; then
    error "Change directory to ${INSTALL_PATH} failed"
  fi

  echoCyan "Clearing up Mattermost directory"
  find mattermost/ mattermost/client/ -mindepth 1 -maxdepth 1 \! \( -type d \( -path mattermost/client -o -path mattermost/client/plugins -o -path mattermost/config -o -path mattermost/logs -o -path mattermost/plugins -o -path mattermost/data -o -path mattermost/yourFolderHere \) -prune \) | sort | xargs rm -r

  echoCyan "Copy new files into Mattermost path"
  cp -an "${TMP}/mattermost-upgrade/." "${INSTALL_PATH}/mattermost/"

  echoCyan "Starting Mattermost service"
  systemctl start mattermost

  echoCyan "Cleaning up temporary working direcroty"
  rm -rf "${TMP}"

  echoCyan "Upgrade process is finished!"
  echoCyan "Please give it a few seconds to finish the migration and bootstrap process..."
}
