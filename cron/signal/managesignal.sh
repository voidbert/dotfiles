#!/bin/sh

# --------------------------------------------- ABOUT ---------------------------------------------
#
# Solution for installing and updating a rootfs with Debian trixie and signal-cli. Debian trixie is
# used, as OpenJDK 21 is not available on bookworm. This file is based on signal-cli-rest-api's
# Dockerfile, but without the parts pertaining to the REST API.
#
# -------------------------------------------- LICENSE --------------------------------------------
#
# Copyright 2024 Humberto Gomes
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# ----------------------------------------- CONFIGURATION -----------------------------------------

CLI_REPO="AsamK/signal-cli"
API_REPO="bbernhard/signal-cli-rest-api"
SERVER_ARCH="armv7" # x86-64 / arm64 / armv7
ROOTFS_PATH="$HOME/cron/signal/signal-cli-rootfs"

# ---------------------------------------------- CODE ----------------------------------------------

# Asks the user to confirm the execution of an operation previously described (yes/no prompt).
#
# return - 0 if the action must be perfomed, 1 if the action was canceled or the input was invalid.
yesno() {
    stdbuf -o 0 printf "Confirm [Y/n]? "
    IFS= read -r yn
    if ! echo "$yn" | grep -Eq '^[Yy]([Ee][Ss])?$'; then
        echo "Operation canceled ..." 1>&2
        return 1
    fi

    return 0
}

# Gets the newest and currently installed versions of the software.
#
# return - 0 on success, 1 on failure.
# stdout - Shell code to be evaluated, with the values of the following variables:
#   Always:
#     newest_api_version - Most recent version of signal-cli-rest-api
#     newest_cli_version - Most recent version of signal-cli
#     newest_lib_version - Most recent version of libsignal_jni in signal-cli-rest-api's repository
#   If the signal-cli is installed already installed:
#     current_cli_version - Currently installed version of signal-cli
#     current_lib_version - Currently installed version of libsignal_jni
get_versions() {
    newest_api_version="$(curl -s -S -L -H "X-GitHub-Api-Version: 2022-11-28" \
        "https://api.github.com/repos/$API_REPO/releases" | jq -r '.[0].tag_name')" || return 1
    dockerfile=$(mktemp)
    curl -s -S -L "https://raw.githubusercontent.com/$API_REPO/$newest_api_version/Dockerfile" \
        -o "$dockerfile" || (rm "$dockerfile" && return 1)

    newest_cli_version=$(grep 'ARG SIGNAL_CLI_VERSION=' "$dockerfile" | sed 's/^[^=]*=//')
    if echo "$newest_cli_version" | grep -q '[^0-9.]'; then
        echo "Invalid signal-cli version: $newest_cli_version" 1>&2
        rm "$dockerfile"
        return 1
    fi

    newest_lib_version=$(grep 'ARG LIBSIGNAL_CLIENT_VERSION=' "$dockerfile" | sed 's/^[^=]*=//')
    if echo "$newest_lib_version" | grep -q '[^0-9.]'; then
        echo "Invalid libsignal_jni version: $newest_lib_version" 1>&2
        rm "$dockerfile"
        return 1
    fi

    echo "newest_api_version=\"$newest_api_version\""
    echo "newest_cli_version=\"$newest_cli_version\""
    echo "newest_lib_version=\"$newest_lib_version\""

    if [ -d "$ROOTFS_PATH" ] && ! cat "$ROOTFS_PATH/home/signal/.signal_version"; then
        rm "$dockerfile"
        return 1
    fi

    rm "$dockerfile"
    return 0
}

# Defines useful variables based on the most recent versions. Must be called after get_versions().
# 
# stdout - Shell code to be evaluated, with the values of the following variables:
#   cli_url      - URL to download signal-cli's release tarball
#   lib_url      - URL to download libsignal_jni's .so file
#   version_file - Contents of $ROOTFS_PATH/home/signal/.signal_version after installation
process_version_data() {
    echo "cli_url=\"https://github.com/$CLI_REPO/releases/download/v$newest_cli_version/signal-cli-$newest_cli_version.tar.gz\""
    echo "lib_url=\"https://raw.githubusercontent.com/$API_REPO/$newest_api_version/ext/libraries/libsignal-client/v$newest_lib_version/$SERVER_ARCH/libsignal_jni.so\""
    echo "version_file=\"$(printf "current_cli_version=\"%s\"\ncurrent_lib_version=\"%s\"\n" \
        "$newest_cli_version" "$newest_lib_version")\""
}

# Code to be run as root that mounts essential system directories, changes the root directory to
# $ROOTFS_PATH, and finally unmounts the mounted directories.
mount_and_chroot="
    mount -t proc none \"$ROOTFS_PATH/proc\" &&
    mount -t sysfs none \"$ROOTFS_PATH/sys\" &&
    mount -t devtmpfs none \"$ROOTFS_PATH/dev\" &&
    mount -t devpts none \"$ROOTFS_PATH/dev/pts\" &&
    chroot \"$ROOTFS_PATH\" /bin/sh ;
    umount \"$ROOTFS_PATH/proc\" ;
    umount \"$ROOTFS_PATH/sys\" ;
    umount \"$ROOTFS_PATH/dev/pts\" ;
    umount \"$ROOTFS_PATH/dev\"
"

# Code path for ./managesignal.sh install
#
# return - 0 on success, 1 on failure.
install_signal() {
    ! command -v debootstrap > /dev/null && echo "debootstrap is not installed!" 1>&2 && return 1
    [ -e "$ROOTFS_PATH" ] && echo "$ROOTFS_PATH already exists!" 1>&2 && return 1

    versions="$(get_versions)" || return 1
    eval "$versions"
    echo "Installing:"
    echo ""
    echo "libsignal-jni v$newest_lib_version"
    echo "signal-cli    v$newest_cli_version"
    echo ""
    yesno || return 1
    eval "$(process_version_data)"

    echo "
        dpkg-reconfigure debconf --frontend=noninteractive &&
        apt -qqy update &&
        apt -qqy upgrade &&
        apt -qqy install zip wget openjdk-21-jre-headless &&
        wget -q \"$lib_url\" -O /usr/lib/libsignal_jni.so &&
        wget -q \"$cli_url\" -O - 2> /dev/null | tar -xzf - -C /opt &&
        ln -s /opt/signal-cli-$newest_cli_version/bin/signal-cli /usr/bin/signal-cli &&
        cd /usr/lib && zip -qu /opt/signal-cli-$newest_cli_version/lib/libsignal-client-$newest_lib_version.jar libsignal_jni.so &&
        groupadd -g 1000 signal &&
        useradd -l -m -s /bin/sh -u 1000 -g 1000 signal &&
        echo \"$version_file\" > /home/signal/.signal_version &&
        mkdir -p /home/signal/.local/share/signal-cli
    " | doas /bin/sh -c "
        debootstrap trixie \"$ROOTFS_PATH\" https://deb.debian.org/debian > /dev/null &&
        $mount_and_chroot
    "
}

# Code path for ./managesignal.sh update
#
# return - 0 on success, 1 on failure.
update_signal() {
    ! [ -d "$ROOTFS_PATH" ] && echo "$ROOTFS_PATH is not a directory!" 1>&2 && return 1

    versions="$(get_versions)" || return 1
    eval "$versions"
    echo "Updating:"
    echo ""
    echo "apt updates   maybe?"
    [ "$current_lib_version" != "$newest_lib_version" ] && \
        echo "libsignal-jni v$current_lib_version -> v$newest_lib_version"
    [ "$current_cli_version" != "$newest_cli_version" ] && \
        echo "signal-cli    v$current_cli_version -> v$newest_cli_version"
    echo ""
    yesno || return 1
    eval "$(process_version_data)"

    echo "
        apt -qqy update &&
        apt -qqy upgrade &&
        $([ "$current_lib_version" != "$newest_lib_version" ] && \
            echo "wget -q \"$lib_url\" -O /tmp/libsignal_jni.so &&")
        $([ "$current_cli_version" != "$newest_cli_version" ] && \
            echo "wget -q \"$cli_url\" -O - 2> /dev/null | tar -xzf --overwrite - -C /opt &&")
        cd /usr/lib && zip -qu /opt/signal-cli-$newest_cli_version/lib/libsignal-client-$newest_lib_version.jar libsignal_jni.so &&
        echo \"$version_file\" > /home/signal/.signal_version
    " | doas /bin/sh -c "$mount_and_chroot"
}

# Code path for ./managesignal.sh uninstall
#
# return - 0 on success, 1 on failure.
uninstall_signal() {
    ! [ -d "$ROOTFS_PATH" ] && echo "$ROOTFS_PATH is not a directory!" 1>&2 && return 1

    echo "Removing: $ROOTFS_PATH"
    yesno || return 1

    doas rm -rf "$ROOTFS_PATH"
}

if [ "$#" -eq 1 ] && [ "$1" = "install" ]; then
    install_signal
elif [ "$#" -eq 1 ] && [ "$1" = "update" ]; then
    update_signal
elif [ "$#" -eq 1 ] && [ "$1" = "uninstall" ]; then
    uninstall_signal
else
    echo "Usage: $0 (install|update|uninstall)" 1>&2
fi
