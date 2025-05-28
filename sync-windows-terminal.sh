#!/bin/bash

WINDOWS_PATH="/mnt/c/Users/david/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json"
REPO_PATH="$(dirname "$0")/settings.json"

function sync_to_repo() {
  echo "Syncing from Windows Terminal to repository..."
  cp "$WINDOWS_PATH" "$REPO_PATH"
  echo "Done!"
}

function sync_to_windows() {
  echo "Syncing from repository to Windows Terminal..."
  cp "$REPO_PATH" "$WINDOWS_PATH"
  echo "Done! Windows Terminal settings updated."
}

function show_diff() {
  diff -u "$WINDOWS_PATH" "$REPO_PATH" || true
}

case "$1" in
  to-repo)
    sync_to_repo
    ;;
  to-windows)
    sync_to_windows
    ;;
  diff)
    show_diff
    ;;
  *)
    echo "Usage: $0 {to-repo|to-windows|diff}"
    echo "  to-repo    : Copy Windows Terminal settings to the repository"
    echo "  to-windows : Copy repository settings to Windows Terminal"
    echo "  diff       : Show differences between the two files"
    exit 1
    ;;
esac
