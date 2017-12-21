setup() {
  docker history "troyfontaine/x86_64-alpinelinux:3.7" >/dev/null 2>&1
}

@test "x86_64 3.7 version is correct" {
  run docker container run --rm troyfontaine/x86_64-alpinelinux:3.7 cat /etc/os-release
  [ $status -eq 0 ]
  [ "${lines[2]}" = "VERSION_ID=3.7.0" ]
}

@test "x86_64 3.7 package installs cleanly" {
  run docker container run --rm troyfontaine/x86_64-alpinelinux:3.7 apk add --no-cache openssl
  [ $status -eq 0 ]
}

@test "x86_64 3.7 timezone" {
  run docker container run --rm troyfontaine/x86_64-alpinelinux:3.7 date +%Z
  [ $status -eq 0 ]
  [ "$output" = "UTC" ]
}

@test "x86_64 3.7 repository list is correct" {
  run docker container run --rm troyfontaine/x86_64-alpinelinux:3.7 cat /etc/apk/repositories
  [ $status -eq 0 ]
  [ "${lines[0]}" = "http://dl-cdn.alpinelinux.org/alpine/v3.7/main" ]
  [ "${lines[1]}" = "http://dl-cdn.alpinelinux.org/alpine/v3.7/community" ]
}

@test "x86_64 3.7 cache is empty" {
  run docker container run --rm troyfontaine/x86_64-alpinelinux:3.7 sh -c "ls -1 /var/cache/apk | wc -l"
  [ $status -eq 0 ]
  [ "$output" = "0" ]
}

@test "x86_64 3.7 root password is disabled" {
  run docker container run --rm --user nobody troyfontaine/x86_64-alpinelinux:3.7 su
  [ $status -eq 1 ]
}
