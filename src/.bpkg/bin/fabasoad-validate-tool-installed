#!/usr/bin/env bash

# Validates that tool is installed on the machine.
# Parameters:
# 1. (Required) Param name to display it correctly in the error message for the
#    users.
# 2. (Required) Param value that will be validated.
#
# Usage example:
# fabasoad_validate_tool_installed "my-tool" "jq"
fabasoad_validate_tool_installed() {
  if ! command -v "${2}" &> /dev/null; then
    printf "\"%s\" parameter is invalid. %s is not installed on the current machine.\n" "${1}" "${2}" >&2
    exit 1
  fi
}

## export
if [[ ${BASH_SOURCE[0]} != $0 ]]; then
  export -f fabasoad_validate_tool_installed
else
  fabasoad_validate_tool_installed "${@}"
  exit $?
fi
