#!/bin/bash
# Keep a GIT repository in sync. Run me in a cronjob!
#
# For better performance, keep the GIT SSH connection open
# File: ~/.ssh/config
# ControlMaster auto
# ControlPath /tmp/%r@%h:%p
# ControlPersist yes

GIT_DIR=$(echo "$1" | tr -s /)
GIT_URL="$2"
GIT_BRANCH="${3:-master}"

# I sleep like a baby at night
mkdir -p "$GIT_DIR"

if [[ ! -d "$GIT_DIR" ]]; then
	git -b "$GIT_BRANCH" clone "$GIT_URL" "$GIT_DIR"
else
	cd "$GIT_DIR" && git -q pull origin "$GIT_BRANCH"
fi
