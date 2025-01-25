#!/usr/bin/env bash

# Validates string to be one of the possible values (emulating enum data type).
# Parameters:
# 1. (Required) Param name to display it correctly in the error message for the
#    users.
# 2. (Required) Param value that will be validated.
# 3. (Required) Possible values for the param value to be valid.
#
# Usage examples:
# fabasoad_validate_enum "my-bool-param" "true" "true,false"
# fabasoad_validate_enum "my-days-of-week-param" "wed" "mon,tue,wed,thu,fri,sat,sun"
fabasoad_validate_enum() {
  case ",${3}," in
    *",${2},"*)
      ;;
    *)
      printf "\"%s\" parameter is invalid. Possible values: %s.\n" "${1}" "$(echo "${3}" | sed 's/,/, /g')" >&2
      exit 1
      ;;
  esac
}

## export
if [[ ${BASH_SOURCE[0]} != $0 ]]; then
  export -f fabasoad_validate_enum
else
  fabasoad_validate_enum "${@}"
  exit $?
fi
