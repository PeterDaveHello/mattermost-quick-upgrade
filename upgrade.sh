#!/bin/sh

{

  set -ex

  error() {
    >&2 echo "$@"
    exit 1
  }

  if [ "$(id -u)" != "0" ]; then
    error "Please give me root permission"
  fi

  MATTERMOST_VERSION="${MATTERMOST_VERSION:-5.38.2}"
  INSTALL_PATH="${INSTALL_PATH:-/opt}"

  if ! [ -e "${INSTALL_PATH}/mattermost/bin/mattermost" ]; then
    error "${INSTALL_PATH} doesn't seem to be the right path!"
  fi

  TMP="$(mktemp -d --suffix=-mattermost)"

  if ! cd "${TMP}"; then
    error "Change directory to ${TMP} failed"
  fi

  wget "https://releases.mattermost.com/$MATTERMOST_VERSION/mattermost-$MATTERMOST_VERSION-linux-amd64.tar.gz" -O "mattermost-linux-amd64.tar.gz"

  tar -xf mattermost-linux-amd64.tar.gz --transform='s,^[^/]\+,\0-upgrade,'

  chown -hR mattermost:mattermost ./mattermost-upgrade/

  systemctl stop mattermost

  cp -ra "${INSTALL_PATH}/mattermost/" "${INSTALL_PATH}/mattermost-back-$(date +'%F-%H-%M')/"

  if ! cd "${INSTALL_PATH}"; then
    error "Change directory to ${INSTALL_PATH} failed"
  fi

  find mattermost/ mattermost/client/ -mindepth 1 -maxdepth 1 \! \( -type d \( -path mattermost/client -o -path mattermost/client/plugins -o -path mattermost/config -o -path mattermost/logs -o -path mattermost/plugins -o -path mattermost/data -o -path mattermost/yourFolderHere \) -prune \) | sort | xargs rm -r

  cp -an "${TMP}/mattermost-upgrade/." "${INSTALL_PATH}/mattermost/"

  systemctl start mattermost

  rm -rf "${TMP}"

}
