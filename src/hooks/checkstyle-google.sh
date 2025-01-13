#!/usr/bin/env sh
set -u

checkstyle_google() {
  checkstyle_common ". -c ${CONFIG_CACHE_APP_DIR}/google_checks.xml $@"
}
