#!/usr/bin/env sh
set -u

checkstyle_common() {
  # Possible values: custom, google, sun
  config_type="${1}"
  # Removing trailing space (sed command) is needed here in case there were no
  # --checkstyle-args passed, so that $1 in this case is "scan . "
  checkstyle_args="$(echo "${2}" | sed 's/ *$//')"

  # Install checkstyle
  checkstyle_path="$(install_checkstyle)"
  checkstyle_version=$(java -jar ${checkstyle_path} --version | cut -d ' ' -f 3)

  # Download config if needed
  case "${config_type}" in
    google)
      checkstyle_config_path="$(download_checkstyle_config_path "${checkstyle_version}" "google")"
      checkstyle_args="${checkstyle_args} -c ${checkstyle_config_path}"
      ;;
    sun)
      checkstyle_config_path="$(download_checkstyle_config_path "${checkstyle_version}" "sun")"
      checkstyle_args="${checkstyle_args} -c ${checkstyle_config_path}"
      ;;
    *)
  esac

  fabasoad_log "info" "Checkstyle path: ${checkstyle_path}"
  fabasoad_log "info" "Checkstyle version: ${checkstyle_version}"
  fabasoad_log "info" "Checkstyle arguments: ${checkstyle_args}"

  fabasoad_log "debug" "Run Checkstyle scanning:"
  set +e
  java -jar ${checkstyle_path} ${checkstyle_args}
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
