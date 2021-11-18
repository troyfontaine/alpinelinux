# Multi-Architecture Alpine Linux (Containerized)

[![Build-and-Release](https://github.com/troyfontaine/alpinelinux/actions/workflows/merge-request.yml/badge.svg)](https://github.com/troyfontaine/alpinelinux/actions/workflows/merge-request.yml)
[![](https://img.shields.io/docker/pulls/troyfontaine/alpinelinux?style=plastic)]
[![](https://img.shields.io/docker/stars/troyfontaine/alpinelinux?style=plastic)]
[![](https://img.shields.io/github/license/troyfontaine/alpinelinux?style=plastic)]

This is a multi-architecture container image for amd64, arm64 and armhf (for now) which is created using the Docker [buildx bake](https://docs.docker.com/engine/reference/commandline/buildx_bake/) and [buildx imagetools create](https://docs.docker.com/engine/reference/commandline/buildx_imagetools_create/)functionality.  Images are built using a Go-Task Taskfile that helps build a multi-stage Dockerfile.

Originally this repository was a branched build process from the awesome folks over at [Gliderlabs][gliderlabs], but with the advances in multi-architecture tooling from Docker, a refactoring was in order.

## Repository Dependencies

With some refactoring to make the build process more efficient and try to simplify "how" this is built, some dependencies have been added.

- [Go Task](https://github.com/go-task/task)
- [GitHub Actions](https://docs.github.com/en/actions)
- [Docker Buildx](https://docs.docker.com/buildx/working-with-buildx/)
- [bats-core](https://github.com/bats-core/bats-core)

## Builds

This is intended to automatically build using CI on a daily basis via scheduled job.

## Why?

Depending on the base-image you use, many are heavily burdened with needed packages.  Alpine is different due to the way it is written from the ground up for saving storage space.  This makes it ideal to use for a base image for Docker containers.

```
REPOSITORY                          TAG           IMAGE ID          VIRTUAL SIZE
troyfontaine/armhf-alpinelinux      latest        78ccb6f52e56      19 MB
debian                              latest        4d6ce913b130      84.98 MB
ubuntu                              latest        b39b81afc8ca      188.3 MB
centos                              latest        8efe422e6104      210 MB
```

There are images such as `progrium/busybox` which get us very close to a minimal container and package system. But these particular BusyBox builds piggyback on the OpenWRT package index which is often lacking and not tailored towards generic everyday applications. Alpine Linux has a much more complete and up to date [package index][alpine-packages]

This makes Alpine Linux a great image base for utilities and even production applications. [Read more about Alpine Linux here][alpine-about] and you can see how their mantra fits in right at home with Docker images.

## Documentation

Updated documentation is a work in progress at the moment

## Contacts

Got a problem? [Submit a GitHub issue][issues] if you have a security or other general question about this Docker image. Please email [security](http://lists.alpinelinux.org/alpine-security/summary.html) or [user](http://lists.alpinelinux.org/alpine-user/summary.html) mailing lists if you have concerns specific to Alpine Linux.

## License

The code in this repository, unless otherwise noted, is MIT licensed. See the `LICENSE` file in this repository.

[alpine-packages]: http://pkgs.alpinelinux.org/
[alpine-about]: https://www.alpinelinux.org/about/
[issues]: https://github.com/troyfontaine/alpinelinux/issues
[alpine]: http://alpinelinux.org/
[hub]: https://hub.docker.com/r/troyfontaine/alpinelinux/
[gliderlabs]: https://github.com/gliderlabs
