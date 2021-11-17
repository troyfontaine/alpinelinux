#!/usr/bin/env bats

load '/usr/local/lib/bats-support/load.bash'
load '/usr/local/lib/bats-assert/load.bash'

# setup() {
#   docker history troyfontaine/alpinelinux:test-candidate >/dev/null 2>&1
# }

@test "${ARCH} ${VERSION} version is correct" {
  run docker container run --rm --platform linux/${TARGET_ARCH} troyfontaine/alpinelinux:test-candidate cat /etc/os-release
  [ $status -eq 0 ]
  [ "${lines[2]}" = "VERSION_ID=${RELEASE}" ]
}

@test "${ARCH} ${VERSION} architecture is correct" {
  run docker container run --rm --platform linux/${TARGET_ARCH} troyfontaine/alpinelinux:test-candidate uname -m
  [ $status -eq 0 ]
  assert_output --partial "${ALPINE_ARCH}"
}

@test "${ARCH} ${VERSION} package installs cleanly" {
  run docker container run --rm --platform linux/${TARGET_ARCH} troyfontaine/alpinelinux:test-candidate apk add --no-cache openssl
  [ $status -eq 0 ]
}

@test "${ARCH} ${VERSION} timezone" {
  run docker container run --rm --platform linux/${TARGET_ARCH} troyfontaine/alpinelinux:test-candidate date +%Z
  [ $status -eq 0 ]
  [ "$output" = "UTC" ]
  #assert_output --partial "UTC"
}

@test "${ARCH} ${VERSION} repository list is correct" {
  run docker container run --rm --platform linux/${TARGET_ARCH} troyfontaine/alpinelinux:test-candidate cat /etc/apk/repositories
  [ $status -eq 0 ]
  [ "${lines[0]}" = "http://dl-cdn.alpinelinux.org/alpine/v${VERSION}/main" ]
  [ "${lines[1]}" = "http://dl-cdn.alpinelinux.org/alpine/v${VERSION}/community" ]
}

@test "${ARCH} ${VERSION} cache is empty" {
  run docker container run --rm --platform linux/${TARGET_ARCH} troyfontaine/alpinelinux:test-candidate sh -c "ls -1 /var/cache/apk | wc -l"
  [ $status -eq 0 ]
  [ "$output" = "0" ]
}

@test "${ARCH} ${VERSION} root password is disabled" {
  run docker container run --rm --user nobody --platform linux/${TARGET_ARCH} troyfontaine/alpinelinux:test-candidate su
  [ $status -eq 1 ]
}
