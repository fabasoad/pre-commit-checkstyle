#!/usr/bin/env bash

PRE_COMMIT_CHECKSTYLE_SRC_DIR=$(dirname $(realpath "$0"))

# Import all scripts
_import_all() {
  current_file=$(realpath "$0")
  exec_files=$(find "${PRE_COMMIT_CHECKSTYLE_SRC_DIR}" -type f \( -perm -u=x -o -perm -g=x -o -perm -o=x \))
  for file in $exec_files; do
    if [ "${file}" != "${current_file}" ]; then
      . "${file}"
    fi
  done
}

# Validate that all needed dependencies are installed on the machine
_validate_prerequisites() {
  validate_tool_installed "jq"
  validate_tool_installed "curl"
  validate_bash_version
}

main() {
  _import_all
  _validate_prerequisites

  cmd_checkstyle="checkstyle"
  cmd_checkstyle_google="checkstyle-google"
  cmd_checkstyle_sun="checkstyle-sun"

  cmd_actual="${1}"
  shift

  # pre-commit passes the files matched by "types: [java]" in
  # .pre-commit-hooks.yaml as separate arguments that start with neither
  # --hook-args nor --checkstyle-args. Separate them from the hook and
  # checkstyle arguments, so that only those files are scanned. If no
  # files are passed, the current directory is scanned as before.
  filenames=""
  hook_checkstyle_args=""
  for arg in "$@"; do
    case "${arg}" in
      --hook-args*|--checkstyle-args*)
        hook_checkstyle_args="${hook_checkstyle_args} ${arg}"
        ;;
      "")
        ;;
      *)
        filenames="${filenames} ${arg}"
        ;;
    esac
  done
  filenames=$(echo "${filenames}" | sed 's/^ *//')

  declare -A all_args_map
  parse_all_args all_args_map "$(echo "${hook_checkstyle_args}" | sed 's/^ *//' | sed 's/ *$//')"
  declare -A hook_args_map
  parse_hook_args hook_args_map "${all_args_map["hook-args"]}"

  # Apply configs
  set +u
  apply_logging_config \
    "${hook_args_map["${CONFIG_LOG_LEVEL_ARG_NAME}"]}" \
    "${hook_args_map["${CONFIG_LOG_COLOR_ARG_NAME}"]}"
  apply_cache_config "${hook_args_map["${CONFIG_CLEAN_CACHE_ARG_NAME}"]}"
  apply_checkstyle_config "${hook_args_map["${CONFIG_CHECKSTYLE_VERSION_ARG_NAME}"]}"

  if [ "${#hook_args_map[@]}" -ne 0 ]; then
    fabasoad_log "info" "Pre-commit hook arguments: $(map_to_str hook_args_map)"
  fi
  set -u

  case "${cmd_actual}" in
    "${cmd_checkstyle}")
      checkstyle_custom "${all_args_map["checkstyle-args"]}" "${filenames}"
      ;;
    "${cmd_checkstyle_google}")
      checkstyle_google "${all_args_map["checkstyle-args"]}" "${filenames}"
      ;;
    "${cmd_checkstyle_sun}")
      checkstyle_sun "${all_args_map["checkstyle-args"]}" "${filenames}"
      ;;
    *)
      validate_enum "${cmd_actual}" "${cmd_checkstyle},${cmd_checkstyle_google},${cmd_checkstyle_sun}"
      ;;
  esac
}

main "$@"
