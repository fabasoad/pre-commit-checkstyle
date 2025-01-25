#!/usr/bin/env bash

# Validates that passed value is a path to an existing file.
# Parameters:
# 1. (Required) Param name to display it correctly in the error message for the
#    users.
# 2. (Required) Param value that will be validated.
#
# Usage example:
# fabasoad_validate_file_exists "my-file-param" "/usr/local/project/requirements.txt"
fabasoad_validate_file_exists() {
  if [ ! -f "${2}" ]; then
    printf "\"%s\" parameter is invalid. \"%s\" is not a file or does not exist.\n" "${1}" "${2}" >&2
    exit 1
  fi
}

## export
if [[ ${BASH_SOURCE[0]} != $0 ]]; then
  export -f fabasoad_validate_file_exists
else
  fabasoad_validate_file_exists "${@}"
  exit $?
fi
