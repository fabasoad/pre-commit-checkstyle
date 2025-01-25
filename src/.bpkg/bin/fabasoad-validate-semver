#!/usr/bin/env bash

# Validates value to be a valid semver string.
# Parameters:
# 1. (Required) Param name to display it correctly in the error message for the
#    users.
# 2. (Required) Param value that will be validated.
#
# Usage examples:
# fabasoad_validate_semver "my-valid-semver-1" "1.2.3"
# fabasoad_validate_semver "my-valid-semver-2" "1.2.3-rc-1"
#
# Reference:
# Validation logic is taken from https://github.com/semver/semver/issues/981
fabasoad_validate_semver() {
  # Regex for a semver digit
  D='0|[1-9][0-9]*'
  # Regex for a semver pre-release word
  PW='[0-9]*[a-zA-Z-][0-9a-zA-Z-]*'
  # Regex for a semver build-metadata word
  MW='[0-9a-zA-Z-]+'

  if ! [[ "${2}" =~ ^($D)\.($D)\.($D)(-(($D|$PW)(\.($D|$PW))*))?(\+($MW(\.$MW)*))?$ ]]; then
    printf "\"%s\" parameter is invalid. \"%s\" is not a valid semver.\n" "${1}" "${2}" >&2
    exit 1
  fi
}

## export
if [[ ${BASH_SOURCE[0]} != $0 ]]; then
  export -f fabasoad_validate_semver
else
  fabasoad_validate_semver "${@}"
  exit $?
fi
