# Alpine Linux (Dockerized)

Current Build Status: [![CircleCI](https://circleci.com/gh/troyfontaine/alpinelinux.svg?style=svg)](https://circleci.com/gh/troyfontaine/alpinelinux)  

Multi-arch (latest):  
[![](https://images.microbadger.com/badges/image/troyfontaine/alpinelinux.svg)](https://microbadger.com/images/troyfontaine/alpinelinux "Get your own image badge on microbadger.com")
[![](https://images.microbadger.com/badges/version/troyfontaine/alpinelinux.svg)](https://microbadger.com/images/troyfontaine/alpinelinux "Get your own version badge on microbadger.com")
[![Docker Stars](https://img.shields.io/docker/stars/troyfontaine/alpinelinux.svg)]()
[![Docker Pulls](https://img.shields.io/docker/pulls/troyfontaine/alpinelinux.svg)]()  
ARMHF with QEMU (Latest):  
[![](https://images.microbadger.com/badges/image/troyfontaine/armhf-alpinelinux.svg)](https://microbadger.com/images/troyfontaine/armhf-alpinelinux "Get your own image badge on microbadger.com")
[![](https://images.microbadger.com/badges/version/troyfontaine/armhf-alpinelinux.svg)](https://microbadger.com/images/troyfontaine/armhf-alpinelinux "Get your own version badge on microbadger.com")
[![Docker Stars](https://img.shields.io/docker/stars/troyfontaine/armhf-alpinelinux.svg)]()
[![Docker Pulls](https://img.shields.io/docker/pulls/troyfontaine/armhf-alpinelinux.svg)]()  
ARMHF(Latest):  
[![](https://images.microbadger.com/badges/image/troyfontaine/armhf_min-alpinelinux.svg)](https://microbadger.com/images/troyfontaine/armhf_min-alpinelinux "Get your own image badge on microbadger.com")
[![](https://images.microbadger.com/badges/version/troyfontaine/armhf_min-alpinelinux.svg)](https://microbadger.com/images/troyfontaine/armhf_min-alpinelinux "Get your own version badge on microbadger.com")
[![Docker Stars](https://img.shields.io/docker/stars/troyfontaine/armhf_min-alpinelinux.svg)]()
[![Docker Pulls](https://img.shields.io/docker/pulls/troyfontaine/armhf_min-alpinelinux.svg)]()  
x86_64 (Latest):  
[![](https://images.microbadger.com/badges/image/troyfontaine/x86_64-alpinelinux.svg)](https://microbadger.com/images/troyfontaine/x86_64-alpinelinux "Get your own image badge on microbadger.com")
[![](https://images.microbadger.com/badges/version/troyfontaine/x86_64-alpinelinux.svg)](https://microbadger.com/images/troyfontaine/x86_64-alpinelinux "Get your own version badge on microbadger.com")
[![Docker Stars](https://img.shields.io/docker/stars/troyfontaine/x86_64-alpinelinux.svg)]()
[![Docker Pulls](https://img.shields.io/docker/pulls/troyfontaine/x86_64-alpinelinux.svg)]()

A super small set of Docker images based on [Alpine Linux][alpine]. The non-qemu images are roughly 4 MB, while the QEMU image comes in at 10 MB and all have access to a package repository that is much more complete than other BusyBox based images.  The primary image is a multi-platform image for x86_64 and armhf which is created using the [manifest-tool](https://github.com/estesp/manifest-tool) by [Phil Estes](https://twitter.com/estesp).  Images are built using multi-stage Dockerfiles.  This is a fork of [Docker Alpine][gliderlabs] by Gliderlabs.

## Builds

This is intended to automatically build using CircleCI on a daily basis via triggered CRON job.

[multi-arch](https://hub.docker.com/r/troyfontaine/alpinelinux/)  
[ARMHF with QEMU](https://hub.docker.com/r/troyfontaine/armhf-alpinelinux/)  
[ARMHF](https://hub.docker.com/r/troyfontaine/armhf_min-alpinelinux/)  
[x86_64](https://hub.docker.com/r/troyfontaine/x86_64-alpinelinux/)  

## Why?

Docker images today are big. Usually much larger than they need to be. There are a lot of ways to make them smaller, but the Docker populace still jumps to the `ubuntu` base image for most projects. The size savings over `ubuntu` and other bases are huge:

```
REPOSITORY          				TAG           IMAGE ID          VIRTUAL SIZE
troyfontaine/alpinelinux          	latest        78ccb6f52e56      3.97 MB
debian              				latest        4d6ce913b130      84.98 MB
ubuntu              				latest        b39b81afc8ca      188.3 MB
centos              				latest        8efe422e6104      210 MB
```

There are images such as `progrium/busybox` which get us very close to a minimal container and package system. But these particular BusyBox builds piggyback on the OpenWRT package index which is often lacking and not tailored towards generic everyday applications. Alpine Linux has a much more complete and up to date [package index][alpine-packages]:

```console
$ docker run progrium/busybox opkg-install nodejs
Unknown package 'nodejs'.
Collected errors:
* opkg_install_cmd: Cannot install package nodejs.

$ docker run --rm troyfontaine/alpinelinux apk add --no-cache nodejs
fetch http://dl-cdn.alpinelinux.org/alpine/v3.6/main/x86_64/APKINDEX.tar.gz
fetch http://dl-cdn.alpinelinux.org/alpine/v3.6/community/x86_64/APKINDEX.tar.gz
(1/8) Installing ca-certificates (20161130-r2)
(2/8) Installing libcrypto1.0 (1.0.2k-r0)
(3/8) Installing libgcc (6.3.0-r4)
(4/8) Installing http-parser (2.7.1-r1)
(5/8) Installing libssl1.0 (1.0.2k-r0)
(6/8) Installing libstdc++ (6.3.0-r4)
(7/8) Installing libuv (1.11.0-r1)
(8/8) Installing nodejs (6.10.3-r1)
Executing busybox-1.26.2-r5.trigger
Executing ca-certificates-20161130-r2.trigger
OK: 26 MiB in 19 packages
```

This makes Alpine Linux a great image base for utilities and even production applications. [Read more about Alpine Linux here][alpine-about] and you can see how their mantra fits in right at home with Docker images.

## Usage

Stop doing this:

```dockerfile
FROM ubuntu-debootstrap:14.04
RUN apt-get update -q \
  && DEBIAN_FRONTEND=noninteractive apt-get install -qy mysql-client \
  && apt-get clean \
  && rm -rf /var/lib/apt
ENTRYPOINT ["mysql"]
```
This took 19 seconds to build and yields a 164 MB image. Eww. Start doing this:

```dockerfile
FROM troyfontaine/alpinelinux:3.6
RUN apk add --no-cache mysql-client
ENTRYPOINT ["mysql"]
```

Only 3 seconds to build and results in a 36 MB image! Hooray!

## Documentation

Check out the `docs` directory in this repository.

## Contacts

We make reasonable efforts to support our work and are always happy to chat.  Got a problem? [Submit a GitHub issue][issues] if you have a security or other general question about this Docker image. Please email [security](http://lists.alpinelinux.org/alpine-security/summary.html) or [user](http://lists.alpinelinux.org/alpine-user/summary.html) mailing lists if you have concerns specific to Alpine Linux.

## Inspiration



## License

The code in this repository, unless otherwise noted, is BSD licensed. See the `LICENSE` file in this repository.

[alpine-packages]: http://pkgs.alpinelinux.org/
[alpine-about]: https://www.alpinelinux.org/about/
[issues]: https://github.com/troyfontaine/armhf-alpinelinux/issues
[alpine]: http://alpinelinux.org/
[hub]: https://hub.docker.com/r/troyfontaine/armhf-alpinelinux/
