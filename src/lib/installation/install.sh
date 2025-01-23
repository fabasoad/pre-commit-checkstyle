#!/usr/bin/env sh

_fetch_latest_version() {
  url="https://api.github.com/repos/${_UPSTREAM_FULL_REPO_NAME}/releases/latest"
  response=$(curl -sL -X GET \
    -w "%{http_code}" \
    -H "Accept: application/vnd.github+json" \
    -H "X-GitHub-Api-Version: 2022-11-28" \
    "${url}")
  data=$(echo "${response}" | sed '$d')
  status_code=$(echo "${response}" | tail -n 1)
  if [ "${status_code}" -eq 200 ]; then
    version="$(echo "${data}" | jq -r '.tag_name' | sed 's/checkstyle-//')"
  else
    msg="Failed to fetch latest release. Status code: ${status_code}."
    if [ "$(echo "${data}" | jq 'has("message")')" = "true" ]; then
      msg="${msg} Reason: $(echo "${data}" | jq -r '.message')."
    fi
    msg="${msg} Using default value: ${CONFIG_CHECKSTYLE_VERSION_BACKUP_VAL}."
    fabasoad_log "warning" "${msg}"
    version="${CONFIG_CHECKSTYLE_VERSION_BACKUP_VAL}"
  fi
  echo "${version}"
}

_download_checkstyle_config_path() {
  version="${1}"
  config_type="${2}"
  checkstyle_config_path="${3}"
  url="https://raw.githubusercontent.com/${_UPSTREAM_FULL_REPO_NAME}/refs/tags/checkstyle-${version}/src/main/resources/${config_type}_checks.xml"
  curl -qsL "${url}" -o "${checkstyle_config_path}"
}

install_checkstyle_config_path() {
  version="${1}"
  config_type="${2}"
  config_filename="${config_type}_checks.xml"
  checkstyle_config_path="${CONFIG_CACHE_APP_DIR}/${config_filename}"
  if [ -f "${checkstyle_config_path}" ]; then
    fabasoad_log "debug" "Config is found at ${checkstyle_config_path}. Installation skipped"
  else
    if [ "${version}" = "latest" ]; then
      version="$(_fetch_latest_version)"
    fi
    fabasoad_log "debug" "Config is not found. Downloading ${config_filename}..."
    _download_checkstyle_config_path "${version}" "${config_type}" "${checkstyle_config_path}"
    fabasoad_log "debug" "Downloading ${config_filename} completed"
  fi
  echo "${checkstyle_config_path}"
}

_download_checkstyle() {
  version="${1}"
  checkstyle_path="${2}"
  url="https://github.com/${_UPSTREAM_FULL_REPO_NAME}/releases/download/checkstyle-${version}/checkstyle-${version}-all.jar"
  curl -qsL "${url}" -o "${checkstyle_path}"
}

install_checkstyle() {
  version="${1}"
  if [ -f "${CONFIG_CACHE_APP_BIN_DIR}" ]; then
    err_msg="${CONFIG_CACHE_APP_BIN_DIR} existing file prevents from creating"
    err_msg="${err_msg} a cache directory with the same name. Please remove"
    err_msg="${err_msg} this file."
    fabasoad_log "error" "${err_msg}"
    exit 1
  fi
  checkstyle_path="${CONFIG_CACHE_APP_BIN_DIR}/checkstyle.jar"
  mkdir -p "${CONFIG_CACHE_APP_BIN_DIR}"
  if [ -f "${checkstyle_path}" ]; then
    fabasoad_log "debug" "Checkstyle is found at ${checkstyle_path}. Installation skipped"
  else
    if [ "${version}" = "latest" ]; then
      version="$(_fetch_latest_version)"
    fi
    fabasoad_log "debug" "Checkstyle is not found. Downloading checkstyle ${version}..."
    _download_checkstyle "${version}" "${checkstyle_path}"
    fabasoad_log "debug" "Downloading checkstyle completed"
  fi
  echo "${checkstyle_path}"
}
