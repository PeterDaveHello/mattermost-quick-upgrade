# Mattermost Quick Upgrade

A simple shell script to help quickly upgrade an Mattermost Self-Managed Server on systemd based Linux system.

The logic inside is basically ported from the steps in [Mattermost official upgrade guide](https://docs.mattermost.com/administration/upgrade.html).

The latest and recent version numbers of Mattermost can be found on official [Version Archive](https://docs.mattermost.com/upgrade/version-archive.html#mattermost-team-edition) document.

Please note that the script only consider the default Mattermost installation, if you store TLSCert/TLSKey files or other information within your Mattermost folder, you need to modify the script to prevent those files been cleared during the upgrade process.

## Usage

Using root permission to execute the `upgrade.sh` script.

Specify the target version and install path by environment variable `$MATTERMOST_VERSION` and `$INSTALL_PATH`, for example:

```sh
MATTERMOST_VERSION="6.5.1" INSTALL_PATH="/opt" sudo -E ./upgrade.sh
```

By default, the `$INSTALL_PATH` is set to `/opt`, if you didn't use another location for your Mattermost instance, you can ignore that variable.
