#!/usr/bin/env bash

systemctl start --user rclone-mount@cloud
systemctl start --user rclone-mount@mega
systemctl start --user keybase
systemctl start --user kbfs

rclone sync -L "/run/user/$(id -u)/keybase/kbfs/private mega:keybase-backup/private"
rclone sync -L "/run/user/$(id -u)/keybase/kbfs/public mega:keybase-backup/public"
rclone sync -L cloud: mega:cloud-backup
