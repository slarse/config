#! /bin/bash

REPO_PATH="$1"

if [ -z "$REPO_PATH" ]; then
  echo "usage: repo_sandbox <repo_path>"
  exit 1
fi

# need the Node file tree to get Pi
NODE_BIN="$(which node)"
NODE_PREFIX="$(dirname "$(dirname "$NODE_BIN")")"

# Pi needs its config. Mounting it read-only will yield some errors about not
# being able to acquire a lock on the settings file, but it seems to work.
PI_CONFIG=/home/slarse/.pi

bwrap \
  --ro-bind /usr /usr \
  --symlink usr/lib /lib \
  --symlink usr/lib /lib64 \
  --symlink usr/bin /bin \
  --symlink usr/bin /sbin \
  --ro-bind /etc /etc \
  --proc /proc \
  --dev /dev \
  --tmpfs /tmp \
  --tmpfs /home/agent \
  --bind "$REPO_PATH" /workspace \
  --bind ~/.sandbox/cargo /home/agent/.cargo \
  --ro-bind ~/.rustup /home/agent/.rustup \
  --ro-bind "$REPO_PATH/.git/config" /workspace/.git/config \
  --ro-bind "$REPO_PATH/.git/hooks" /workspace/.git/hooks \
  --ro-bind "$NODE_PREFIX" "$NODE_PREFIX" \
  --ro-bind "$PI_CONFIG" /home/agent/.pi \
  --bind "$PI_CONFIG/agent/sessions/" /home/agent/.pi/agent/sessions \
  --setenv HOME /home/agent \
  --setenv PATH "$NODE_PREFIX/bin:/usr/bin" \
  --setenv ANTHROPIC_API_KEY "$ANTHROPIC_API_KEY" \
  --unshare-pid \
  --die-with-parent \
  --chdir /workspace \
  --new-session \
  /bin/bash
