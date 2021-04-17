#!/usr/bin/env bash

START_DIR="${START_DIR:-/home/luis/Workspace}"

PREFIX="dotfiles-web"

mkdir -p "$START_DIR"

# set hostname inside docker
sudo hostname dotty

if [[ ! -z "${WAKATIME_API_KEY}" ]]; then
	echo -e "[settings]\napi_key = $WAKATIME_API_KEY" > "$HOME/.wakatime.cfg"
fi

# add rclone config and start rclone, if supplied
if [[ -z "${RCLONE_DATA}" ]]; then
    echo "[$PREFIX] RCLONE_DATA is not specified. Files will not persist"
else
    echo "[$PREFIX] Copying rclone config..."
    mkdir -p "$HOME/.config/rclone/"
    touch "$HOME/.config/rclone/rclone.conf"
    echo "$RCLONE_DATA" | base64 -d > "$HOME/.config/rclone/rclone.conf"

    # defasult to true
    RCLONE_VSCODE_TASKS="${RCLONE_VSCODE_TASKS:-true}"
    RCLONE_AUTO_PUSH="${RCLONE_AUTO_PUSH:-true}"
    RCLONE_AUTO_PULL="${RCLONE_AUTO_PULL:-true}"

    if [ $RCLONE_VSCODE_TASKS = "true" ]; then
        # copy our tasks config to VS Code
        echo "[$PREFIX] Applying VS Code tasks for rclone"
        cp /tmp/rclone-tasks.json "$HOME/.local/share/code-server/User/tasks.json"
        # install the extension to add to menu bar
        code-server --install-extension actboy168.tasks&
    else
        # user specified they don't want to apply the tasks
        echo "[$PREFIX] Skipping VS Code tasks for rclone"
    fi

    # Full path to the remote filesystem
    RCLONE_REMOTE_PATH=${RCLONE_REMOTE_NAME:-code-server-remote}:${RCLONE_DESTINATION:-code-server-files}
    RCLONE_SOURCE_PATH=${RCLONE_SOURCE:-$START_DIR}
    echo "rclone sync $RCLONE_SOURCE_PATH $RCLONE_REMOTE_PATH $RCLONE_FLAGS -vv" > "$HOME/push_remote.sh"
    echo "rclone sync $RCLONE_REMOTE_PATH $RCLONE_SOURCE_PATH $RCLONE_FLAGS -vv" > "$HOME/pull_remote.sh"
    chmod +x "$HOME/push_remote.sh" "$HOME/pull_remote.sh"

    if rclone ls $RCLONE_REMOTE_PATH; then

        if [ $RCLONE_AUTO_PULL = "true" ]; then
            # grab the files from the remote instead of running project_init()
            echo "[$PREFIX] Pulling existing files from remote..."
            "$HOME"/pull_remote.sh&
        else
            # user specified they don't want to apply the tasks
            echo "[$PREFIX] Auto-pull is disabled"
        fi

    else

        if [ $RCLONE_AUTO_PUSH = "true" ]; then
            # we need to clone the git repo and sync
            echo "[$PREFIX] Pushing initial files to remote..."
            project_init
            "$HOME"/push_remote.sh&
        else
            # user specified they don't want to apply the tasks
            echo "[$PREFIX] Auto-push is disabled"
        fi

    fi

fi

echo "[$PREFIX] Running dotfiles configuration..."

"$HOME"/dotfiles/scripts/apply-dotfiles.sh

mkdir -vp "$HOME/.local/share/code-server/User/"
cp "$HOME/.config/Code/User/settings.json" "$HOME/.local/share/code-server/User/settings.json"
cp "$HOME/.config/Code/User/keybindings.json" "$HOME/.local/share/code-server/User/keybindings.json"

"$HOME"/dotfiles/configure.sh &

echo "[$PREFIX] Starting code-server..."
# Now we can run code-server with the default entrypoint
code-server --bind-addr 0.0.0.0:8080 "$START_DIR"
