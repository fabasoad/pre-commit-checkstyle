#!/usr/bin/env sh

apply_checkstyle_config() {
  checkstyle_version="${1:-${PRE_COMMIT_CHECKSTYLE_CHECKSTYLE_VERSION:-${CONFIG_CHECKSTYLE_VERSION_DEFAULT_VAL}}}"
  if [ "${checkstyle_version}" != "latest" ]; then
    validate_semver "${CONFIG_CHECKSTYLE_VERSION_ARG_NAME}" "${checkstyle_version}"
  fi
  export PRE_COMMIT_CHECKSTYLE_CHECKSTYLE_VERSION="${checkstyle_version}"
}
