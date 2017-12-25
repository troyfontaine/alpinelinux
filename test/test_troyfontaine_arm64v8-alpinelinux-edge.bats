setup() {
  docker history "troyfontaine/arm64v8-alpinelinux:edge" >/dev/null 2>&1
}

@test "ARM64v8 Edge version is correct" {
  run docker container run --rm troyfontaine/arm64v8-alpinelinux:edge cat /etc/os-release
  [ $status -eq 0 ]
  [ "${lines[2]}" = "VERSION_ID=3.7.0" ]
}

@test "ARM64v8 Edge package installs cleanly" {
  run docker container run --rm troyfontaine/arm64v8-alpinelinux:edge apk add --update openssl
  [ $status -eq 0 ]
}

@test "ARM64v8 Edge timezone" {
  run docker container run --rm troyfontaine/arm64v8-alpinelinux:edge date +%Z
  [ $status -eq 0 ]
  [ "$output" = "UTC" ]
}

@test "ARM64v8 Edge repository list is correct" {
  run docker container run --rm troyfontaine/arm64v8-alpinelinux:3.6 cat /etc/apk/repositories
  [ $status -eq 0 ]
  [ "${lines[0]}" = "http://dl-cdn.alpinelinux.org/alpine/v3.6/main" ]
  [ "${lines[1]}" = "http://dl-cdn.alpinelinux.org/alpine/v3.6/community" ]
}

@test "ARM64v8 Edge cache is empty" {
  run docker container run --rm troyfontaine/arm64v8-alpinelinux:edge sh -c "ls -1 /var/cache/apk | wc -l"
  [ $status -eq 0 ]
  [ "$output" = "0" ]
}

@test "ARM64v8 Edge root password is disabled" {
  run docker container run --rm --user nobody troyfontaine/arm64v8-alpinelinux:edge su
  [ $status -eq 1 ]
}
