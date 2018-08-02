setup() {
  docker history "troyfontaine/arm64v8-alpinelinux:3.8" >/dev/null 2>&1
}

@test "ARM64v8 3.8 version is correct" {
  run docker container run --rm troyfontaine/arm64v8-alpinelinux:3.8 cat /etc/os-release
  [ $status -eq 0 ]
  [ "${lines[2]}" = "VERSION_ID=3.8.0" ]
}

@test "ARM64v8 3.8 package installs cleanly" {
  run docker container run --rm troyfontaine/arm64v8-alpinelinux:3.8 apk add --no-cache openssl
  [ $status -eq 0 ]
}

@test "ARM64v8 3.8 timezone" {
  run docker container run --rm troyfontaine/arm64v8-alpinelinux:3.8 date +%Z
  [ $status -eq 0 ]
  [ "$output" = "UTC" ]
}

@test "ARM64v8 3.8 repository list is correct" {
  run docker container run --rm troyfontaine/arm64v8-alpinelinux:3.8 cat /etc/apk/repositories
  [ $status -eq 0 ]
  [ "${lines[0]}" = "http://dl-cdn.alpinelinux.org/alpine/v3.8/main" ]
  [ "${lines[1]}" = "http://dl-cdn.alpinelinux.org/alpine/v3.8/community" ]
}

@test "ARM64v8 3.8 cache is empty" {
  run docker container run --rm troyfontaine/arm64v8-alpinelinux:3.8 sh -c "ls -1 /var/cache/apk | wc -l"
  [ $status -eq 0 ]
  [ "$output" = "0" ]
}

@test "ARM64v8 3.8 root password is disabled" {
  run docker container run --rm --user nobody troyfontaine/arm64v8-alpinelinux:3.8 su
  [ $status -eq 1 ]
}
