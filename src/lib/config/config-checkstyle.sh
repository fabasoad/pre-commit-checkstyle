#!/usr/bin/env sh

apply_checkstyle_config() {
  checkstyle_version="${1:-${PRE_COMMIT_CHECKSTYLE_CHECKSTYLE_VERSION:-${CONFIG_CHECKSTYLE_VERSION_DEFAULT_VAL}}}"
  if [ "${checkstyle_version}" != "latest" ]; then
    validate_semver "${checkstyle_version}" "${CONFIG_CHECKSTYLE_VERSION_ARG_NAME}"
  fi
  export PRE_COMMIT_CHECKSTYLE_CHECKSTYLE_VERSION="${checkstyle_version}"
}
