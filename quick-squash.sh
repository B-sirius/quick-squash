#!/usr/bin/env bash

CURRENT_BRANCH=0

get_branch() {
    CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD | grep -v HEAD ||
        git describe --exact-match HEAD 2>/dev/null ||
        git rev-parse HEAD)
}

TARGET_BRANCH=$1
TEMP_BRANCH="temp-squash"

get_branch

if [ ! "$TARGET_BRANCH" ]; then
    echo 'quick-squash [target branch]'
    echo 'Please enter your target branch'
    exit 1
fi

git checkout "$TARGET_BRANCH"
git checkout -b "$TEMP_BRANCH"
git merge --squash "$CURRENT_BRANCH"

read -r -p "> commit message: " COMMIT_MESSAGE

git commit -m "$COMMIT_MESSAGE"

git checkout "$CURRENT_BRANCH"
git reset --hard "$TEMP_BRANCH"

git branch --delete "$TEMP_BRANCH"