#!/usr/bin/env sh
set -u

checkstyle_google() {
  checkstyle_common "google" ". $@"
}
