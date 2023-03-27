# Mattermost Quick Upgrade

This is a very simple shell script to quickly upgrade a Self-Managed Mattermost Server on systemd-based Linux systems. The logic inside is basically ported from the steps in [Mattermost official upgrade guide](https://docs.mattermost.com/administration/upgrade.html). It allows users to upgrade their Mattermost instance to the latest version with a single command, making the upgrade process faster and more convenient.

**Note:** This script only considers the default Mattermost installation. If you store TLSCert/TLSKey or other files within your Mattermost folder, pleas backup those important files, and modify the script to prevent those files from being cleared during the upgrade process.

## Usage

Before running the Mattermost Quick Upgrade script, ensure that your system meets the recommended hardware specifications. The script uses these two environment variables; they are both optional, with default values:

- `MATTERMOST_VERSION`: the target version of Mattermost to upgrade to.
  - See the default version in the script itself.
  - The latest and recent version numbers of Mattermost can be found on the official [Version Archive](https://docs.mattermost.com/upgrade/version-archive.html#mattermost-team-edition) document.
- `INSTALL_PATH`: the installation path for Mattermost.
  - Default to `/opt`.
  - If you didn't use another location for your Mattermost instance, you can ignore that variable.

To upgrade, run the script with root permission and corresponding variables like this:

```sh
MATTERMOST_VERSION="<version_number>" INSTALL_PATH="<installation_path>" sudo -E ./upgrade.sh
```

For example:

```sh
MATTERMOST_VERSION="7.3.0" INSTALL_PATH="/opt" sudo -E ./upgrade.sh
```

## Troubleshooting

If you encounter any errors while running the Mattermost Quick Upgrade script, refer to the official [Mattermost upgrade guide](https://docs.mattermost.com/administration/upgrade.html) for troubleshooting steps. If the issue persists, consult the Mattermost community forum for assistance.

We hope that the Mattermost Quick Upgrade script will help simplify the upgrade process and keep your Mattermost server up-to-date with the latest features and security patches.
