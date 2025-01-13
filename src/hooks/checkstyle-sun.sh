#!/usr/bin/env sh
set -u

checkstyle_sun() {
  checkstyle_common ". -c ${CONFIG_CACHE_APP_DIR}/sun_checks.xml $@"
}
