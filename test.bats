#!/usr/bin/env bats

load '/usr/local/lib/bats-support/load.bash'
load '/usr/local/lib/bats-assert/load.bash'

@test "${TARGET_ARCH} ${VERSION} version is correct" {
  run docker container run --rm --platform linux/${TARGET_ARCH} troyfontaine/alpinelinux:test-candidate cat /etc/os-release
  assert_success
#   [ $status -eq 0 ]
#   [ "${lines[2]}" = "VERSION_ID=${RELEASE}" ]
  assert_output --partial "VERSION_ID=${RELEASE}"
}

@test "${TARGET_ARCH} ${VERSION} architecture is correct" {
  run docker container run --rm --platform linux/${TARGET_ARCH} troyfontaine/alpinelinux:test-candidate uname -m
  [ $status -eq 0 ]
  assert_output --partial "${ALPINE_ARCH}"
}

@test "${TARGET_ARCH} ${VERSION} timezone" {
  run docker container run --rm --platform linux/${TARGET_ARCH} troyfontaine/alpinelinux:test-candidate date +%Z
  [ $status -eq 0 ]
  [ "$output" = "UTC" ]
  #assert_output --partial "UTC"
}

@test "${TARGET_ARCH} ${VERSION} repository list is correct and using HTTPS" {
  run docker container run --rm --platform linux/${TARGET_ARCH} troyfontaine/alpinelinux:test-candidate cat /etc/apk/repositories
  assert_success
  assert_output --partial "https://dl-cdn.alpinelinux.org/alpine/v${VERSION}/main"
  assert_output --partial "https://dl-cdn.alpinelinux.org/alpine/v${VERSION}/community"
}

@test "${TARGET_ARCH} ${VERSION} package installs cleanly" {
  run docker container run --rm --platform linux/${TARGET_ARCH} troyfontaine/alpinelinux:test-candidate apk add --no-cache openssl
  [ $status -eq 0 ]
}

@test "${TARGET_ARCH} ${VERSION} cache is empty" {
  run docker container run --rm --platform linux/${TARGET_ARCH} troyfontaine/alpinelinux:test-candidate sh -c "ls -1 /var/cache/apk | wc -l"
  [ $status -eq 0 ]
  [ "$output" = "0" ]
}

@test "${TARGET_ARCH} ${VERSION} root password is disabled" {
  run docker container run --rm --user nobody --platform linux/${TARGET_ARCH} troyfontaine/alpinelinux:test-candidate su
  [ $status -eq 1 ]
}
