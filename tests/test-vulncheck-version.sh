#!/usr/bin/env sh

TESTS_DIR=$(dirname $(realpath "$0"))
ROOT_DIR=$(dirname "${TESTS_DIR}")
SRC_DIR="${ROOT_DIR}/src"

test_checkstyle_version_param_precedence() {
  command="$1"
  checkstyle_version_cmd="$2"
  checkstyle_version_env_var="$3"
  version_expected="$4"

  test_name="${FUNCNAME:-${0##*/}}: $@"

  if command -v checkstyle &> /dev/null; then
    echo "[SKIP] ${test_name} - checkstyle installed globally"
  else
    output=$(PRE_COMMIT_CHECKSTYLE_CHECKSTYLE_VERSION="${checkstyle_version_env_var}" \
      ${SRC_DIR}/main.sh "${command}" \
      "--checkstyle-args=--debug --hook-args=--log-level=info --checkstyle-version=${checkstyle_version_cmd}" \
      2>&1 >/dev/null)

    version_actual=$(echo "${output}" | grep 'Checkstyle version:' | sed 's/.*Checkstyle version: \([0-9.]*\).*/\1/')
    if [ "${version_actual}" != "${version_expected}" ]; then
      echo "[FAIL] ${test_name} - Expected: ${version_expected}. Actual: ${version_actual}"
      echo "\n${output}"
      exit 1
    fi

    echo "[PASS] ${test_name}"
  fi
}

test_checkstyle_version_env_var() {
  command="$1"
  checkstyle_version_env_var="$2"
  version_expected="${checkstyle_version_env_var}"

  test_name="${FUNCNAME:-${0##*/}}: $@"

  if command -v checkstyle &> /dev/null; then
    echo "[SKIP] ${test_name} - checkstyle installed globally"
  else
    output=$(PRE_COMMIT_CHECKSTYLE_CHECKSTYLE_VERSION="${checkstyle_version_env_var}" \
      ${SRC_DIR}/main.sh "${command}" \
      "--checkstyle-args=--debug --hook-args=--log-level=info" \
      2>&1 >/dev/null)

    version_actual=$(echo "${output}" | grep 'Checkstyle version:' | sed 's/.*Checkstyle version: \([0-9.]*\).*/\1/')
    if [ "${version_actual}" != "${version_expected}" ]; then
      echo "[FAIL] ${test_name} - Expected: ${version_expected}. Actual: ${version_actual}"
      echo "\n${output}"
      exit 1
    fi

    echo "[PASS] ${test_name}"
  fi
}

main() {
  echo "Testing $(basename "$0")..."
  test_checkstyle_version_param_precedence "checkstyle-google" "0.8.4" "0.8.5" "0.8.4"
  test_checkstyle_version_param_precedence "checkstyle-google" "0.8.5" "0.8.4" "0.8.5"
  test_checkstyle_version_env_var "checkstyle-google" "0.8.4"
  echo "[PASS] Total 3 tests passed\n"
}

main "$@"
