#!/usr/bin/env bash

set -euo pipefail

import_windows_path() {
  local cmd="/mnt/c/Windows/System32/cmd.exe"
  local wsl_path=""
  local win_path="$("$cmd" /C echo %PATH% 2>/dev/null | tr -d '\r' || true)"

  [[ -n "$win_path" ]] || return 0

  local path translated_path

  while IFS= read -r path; do
    if [[ -z "$path" ]]; then
      continue
    fi

    translated_path="$(wslpath -u "$path" 2>/dev/null || true)"

    if [[ -z "$translated_path" || ! -d "$translated_path" ]]; then
      continue
    fi

    wsl_path+=":$translated_path"
  done < <(tr ';' '\n' <<<"$win_path")

  if [[ -n "$wsl_path" ]]; then
    export PATH="${PATH}${wsl_path}" # wsl_path starts with ':'
  fi
}

import_windows_path

NPIPERELAY="$(dirname "$0")/npiperelay.exe"

WIN_SOCKET="$(
  gpgconf.exe --list-dirs $1 \
    | tr -d '\r' \
    | sed 's|\\|/|g'
)"

exec "$NPIPERELAY" -ep -ei -s -a "$WIN_SOCKET"
