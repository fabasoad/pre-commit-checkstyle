#!/usr/bin/env sh
set -u

checkstyle_custom() {
  checkstyle_common "" ". $@"
}
