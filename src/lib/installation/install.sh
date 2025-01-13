#!/usr/bin/env sh

download_checkstyle_config_path() {
  version="${1}"
  config_type="${2}"
  url="https://raw.githubusercontent.com/${_UPSTREAM_FULL_REPO_NAME}/refs/tags/checkstyle-${version}/src/main/resources/${config_type}_checks.xml"
  checkstyle_config_path="${CONFIG_CACHE_APP_DIR}/${config_type}_checks.xml"
  curl -qsL "${url}" -o "${checkstyle_config_path}"
  echo "${checkstyle_config_path}"
}

download_checkstyle() {
  version="${1}"
  url="https://github.com/${_UPSTREAM_FULL_REPO_NAME}/releases/download/checkstyle-${version}/checkstyle-${version}-all.jar"
  curl -qsL "${url}" -o "${CONFIG_CACHE_APP_BIN_DIR}/checkstyle.jar"
}

install_checkstyle() {
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
    version="${PRE_COMMIT_CHECKSTYLE_CHECKSTYLE_VERSION}"
    if [ "${version}" = "latest" ]; then
      version="$(curl -s "https://api.github.com/repos/${_UPSTREAM_FULL_REPO_NAME}/releases/latest" \
        | grep '"tag_name":' \
        | sed -E 's/.*"([^"]+)".*/\1/' \
        | sed 's/checkstyle-//')"
    fi
    fabasoad_log "debug" "Checkstyle is not found. Downloading ${version} version..."
    download_checkstyle "${version}"
    fabasoad_log "debug" "Downloading completed"
  fi
  echo "${checkstyle_path}"
}
