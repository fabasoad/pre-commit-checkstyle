#!/usr/bin/env sh
set -u

checkstyle_common() {
  # Removing trailing space (sed command) is needed here in case there were no
  # --checkstyle-args passed, so that $1 in this case is "scan . "
  checkstyle_args="$(echo "${1}" | sed 's/ *$//')"

  checkstyle_path=$(install)
  checkstyle_version=$(${checkstyle_path} version | head -n 1 | cut -d ' ' -f 3)
  fabasoad_log "info" "Checkstyle path: ${checkstyle_path}"
  fabasoad_log "info" "Checkstyle version: ${checkstyle_version}"
  fabasoad_log "info" "Checkstyle arguments: ${checkstyle_args}"

  fabasoad_log "debug" "Run Checkstyle scanning:"
  set +e
  ${checkstyle_path} ${checkstyle_args}
  checkstyle_exit_code=$?
  set -e
  fabasoad_log "debug" "Checkstyle scanning completed"
  msg="Checkstyle exit code: ${checkstyle_exit_code}"
  if [ "${checkstyle_exit_code}" = "0" ]; then
    fabasoad_log "info" "${msg}"
  else
    fabasoad_log "error" "${msg}"
  fi

  uninstall
  exit ${checkstyle_exit_code}
}
