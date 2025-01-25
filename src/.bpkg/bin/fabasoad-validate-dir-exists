#!/usr/bin/env bash

# Validates that passed value is a path to an existing directory.
# Parameters:
# 1. (Required) Param name to display it correctly in the error message for the
#    users.
# 2. (Required) Param value that will be validated.
#
# Usage example:
# fabasoad_validate_dir_exists "my-dir-param" "/usr/local/my-dir"
fabasoad_validate_dir_exists() {
  if [ ! -d "${2}" ]; then
    printf "\"%s\" parameter is invalid. \"%s\" is not a directory or does not exist.\n" "${1}" "${2}" >&2
    exit 1
  fi
}

## export
if [[ ${BASH_SOURCE[0]} != $0 ]]; then
  export -f fabasoad_validate_dir_exists
else
  fabasoad_validate_dir_exists "${@}"
  exit $?
fi
