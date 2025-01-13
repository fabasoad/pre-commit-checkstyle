#!/usr/bin/env sh
set -u

checkstyle_sun() {
  checkstyle_common "sun" ". $@"
}
