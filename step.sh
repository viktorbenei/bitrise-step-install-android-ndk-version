#!/usr/bin/env bash
set -ex

# set env vars
uname_platform="$(uname -s)"
if [[ "$uname_platform" == 'Darwin' ]] ; then
  export ANDROID_NDK_PLATFORM='darwin'
elif [[ "$uname_platform" == 'Linux' ]] ; then
  export ANDROID_NDK_PLATFORM='linux'
fi

if [[ "$ANDROID_NDK_HOME" == "" ]] ; then
  if [[ "$ANDROID_NDK_PLATFORM" == 'darwin' ]] ; then
    export ANDROID_NDK_HOME="$HOME/Library/Android/sdk/ndk-bundle"
  elif [[ "$ANDROID_NDK_PLATFORM" == 'linux' ]] ; then
    export ANDROID_NDK_HOME="/opt/android-ndk"
  else
    echo "Unsupported ANDROID_NDK_PLATFORM: $ANDROID_NDK_PLATFORM"
    exit 1
  fi

  # expose for subsequent steps
  envman add --key ANDROID_NDK_HOME --value "$ANDROID_NDK_HOME"
fi


# ------------------------------------------------------
# --- Android NDK

# clean up if a previous version is already installed
mkdir -p "$ANDROID_NDK_HOME"
rm -rf "$ANDROID_NDK_HOME"

# download
mkdir -p /tmp/android-ndk-tmp
cd /tmp/android-ndk-tmp
wget -q https://dl.google.com/android/repository/android-ndk-${android_ndk_version}-${ANDROID_NDK_PLATFORM}-x86_64.zip

# uncompress
unzip -q android-ndk-${android_ndk_version}-${ANDROID_NDK_PLATFORM}-x86_64.zip

# move to its final location
mv ./android-ndk-${android_ndk_version} ${ANDROID_NDK_HOME}

# remove temp dir
cd ${ANDROID_NDK_HOME}
rm -rf /tmp/android-ndk-tmp


# add to PATH
export PATH=${PATH}:${ANDROID_NDK_HOME}
# expose for subsequent steps
envman add --key PATH --value "$PATH"
