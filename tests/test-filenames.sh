#!/usr/bin/env sh

TESTS_DIR=$(dirname $(realpath "$0"))
ROOT_DIR=$(dirname "${TESTS_DIR}")
SRC_DIR="${ROOT_DIR}/src"

# Creates a temporary consumer directory with a stub "java" binary and a
# pre-seeded checkstyle cache, so that no download and no real checkstyle
# run are needed. The stub prints the version in the same format as the
# real checkstyle and exits successfully on a scan run.
prepare_stub() {
  stub_dir=$(mktemp -d)
  mkdir -p "${stub_dir}/bin"
  mkdir -p "${stub_dir}/.fabasoad/pre-commit-checkstyle/bin"
  touch "${stub_dir}/.fabasoad/pre-commit-checkstyle/bin/checkstyle.jar"
  touch "${stub_dir}/.fabasoad/pre-commit-checkstyle/google_checks.xml"
  touch "${stub_dir}/.fabasoad/pre-commit-checkstyle/sun_checks.xml"
  printf '%s\n' '#!/usr/bin/env sh' \
    'for arg in "$@"; do' \
    '  if [ "${arg}" = "--version" ]; then' \
    '    echo "Checkstyle version: 10.21.2"' \
    '    exit 0' \
    '  fi' \
    'done' \
    'exit 0' > "${stub_dir}/bin/java"
  chmod +x "${stub_dir}/bin/java"
}

run_hook() {
  output=$(cd "${stub_dir}" && \
    PATH="${stub_dir}/bin:${PATH}" "${SRC_DIR}/main.sh" "$@" \
    2>&1 >/dev/null)
  echo "${output}" | grep "Checkstyle arguments:"
}

assert_arguments() {
  test_name="${1}"
  arguments_actual="${2}"
  arguments_expected="${3}"

  if [ "${arguments_actual}" != "${arguments_expected}" ]; then
    echo "[FAIL] ${test_name}"
    echo "Expected: ${arguments_expected}"
    echo "Actual: ${arguments_actual}"
    exit 1
  fi

  echo "[PASS] ${test_name}"
}

test_filenames_are_passed() {
  prepare_stub
  arguments_line=$(run_hook "checkstyle-google" \
    "src/main/java/com/example/Foo.java" \
    "src/main/java/com/example/Bar.java")
  arguments_actual=$(echo "${arguments_line}" | sed 's/.*Checkstyle arguments: //')
  arguments_expected="src/main/java/com/example/Foo.java src/main/java/com/example/Bar.java --exclude=.fabasoad -c ${stub_dir}/.fabasoad/pre-commit-checkstyle/google_checks.xml"
  assert_arguments "test_filenames_are_passed: $*" "${arguments_actual}" "${arguments_expected}"
  rm -rf "${stub_dir}"
}

test_filenames_with_checkstyle_args() {
  prepare_stub
  arguments_line=$(run_hook "checkstyle" \
    "--checkstyle-args=-c config.xml" \
    "src/main/java/com/example/Foo.java")
  arguments_actual=$(echo "${arguments_line}" | sed 's/.*Checkstyle arguments: //')
  arguments_expected="src/main/java/com/example/Foo.java -c config.xml --exclude=.fabasoad"
  assert_arguments "test_filenames_with_checkstyle_args: $*" "${arguments_actual}" "${arguments_expected}"
  rm -rf "${stub_dir}"
}

test_no_filenames_scans_current_directory() {
  prepare_stub
  arguments_line=$(run_hook "checkstyle-google")
  arguments_actual=$(echo "${arguments_line}" | sed 's/.*Checkstyle arguments: //')
  arguments_expected=". --exclude=.fabasoad -c ${stub_dir}/.fabasoad/pre-commit-checkstyle/google_checks.xml"
  assert_arguments "test_no_filenames_scans_current_directory: $*" "${arguments_actual}" "${arguments_expected}"
  rm -rf "${stub_dir}"
}

main() {
  echo "Testing $(basename "$0")..."
  test_filenames_are_passed
  test_filenames_with_checkstyle_args
  test_no_filenames_scans_current_directory
  echo "[PASS] Total 3 tests passed\n"
}

main "$@"
