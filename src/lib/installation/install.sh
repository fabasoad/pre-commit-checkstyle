#!/usr/bin/env sh

download_checkstyle() {
  version="${1}"
  os="$(uname -s)"
  arch="$(uname -m)"
  ext=$([ "${os}" = "Linux" ] && echo "tar.gz" || echo "zip")
  if [ "${os}" = "Darwin" ]; then
    os="macOS"
    arch="${arch}"
  else
    os=$([ "${os}" = "Linux" ] && echo "linux" || echo "windows")
    arch=$([ "${arch}" = "aarch64" ] && echo "arm64" || echo "amd64")
  fi
  filename="checkstyle_${version}_${os}_${arch}"
  url="https://github.com/${_UPSTREAM_FULL_REPO_NAME}/releases/download/v${version}/${filename}.${ext}"
  output_filename="checkstyle.${ext}"
  curl -qsL "${url}" -o "${CONFIG_CACHE_APP_BIN_DIR}/${output_filename}"
  if [ "${ext}" = "zip" ]; then
    unzip -qq "${CONFIG_CACHE_APP_BIN_DIR}/${output_filename}" -d "${CONFIG_CACHE_APP_BIN_DIR}"
    mv "${CONFIG_CACHE_APP_BIN_DIR}/${filename}/bin/checkstyle" "${CONFIG_CACHE_APP_BIN_DIR}"
    rm -rf "${CONFIG_CACHE_APP_BIN_DIR}/${filename}"
  else
    tar -xzf "${CONFIG_CACHE_APP_BIN_DIR}/${output_filename}" -C "${CONFIG_CACHE_APP_BIN_DIR}" --strip-components 2
  fi
  rm -f "${CONFIG_CACHE_APP_BIN_DIR}/${output_filename}"
}

install() {
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
