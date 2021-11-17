# syntax=docker/dockerfile:1
# hadolint ignore=DL3029
FROM --platform=$BUILDPLATFORM scratch AS builder

ARG ALPINE_VERSION

ADD alpine.tar.gz /

# hadolint ignore=DL3018
RUN apk add tzdata \
    --no-cache \
    && rm -rf /var/cache/apk/*

FROM scratch

ARG ALPINE_VERSION
ARG BUILD_DATE
ARG VCS_REF
ARG VERSION

ADD alpine.tar.gz /

LABEL org.label-schema.build-date=$BUILD_DATE \
    org.label-schema.docker.dockerfile="/Dockerfile" \
    org.label-schema.license="BSD" \
    org.label-schema.name="alpinelinux" \
    org.label-schema.description="Alpine Linux image" \
    org.label-schema.url="https://alpinelinux.troyfontaine.com" \
    org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.vcs-type="Git" \
    org.label-schema.vcs-url="https://github.com/troyfontaine/alpinelinux" \
    org.label-schema.docker.cmd="docker run --rm troyfontaine/alpinelinux:$ALPINE_VERSION [args]" \
    org.label-schema.schema-version="1.0" \
    com.troyfontaine.architecture=$BUILDPLATFORM \
    com.troyfontaine.alpine-version=$ALPINE_VERSION \
    maintainer="Troy Fontaine"

COPY --from=builder /usr/share/zoneinfo/UTC /etc/localtime

# Fix certificate issues when setting to use the https repositories
# hadolint ignore=DL3018
RUN apk add \
    ca-certificates \
    --no-cache \
    && rm -rf /var/cache/apk/*

# Upgrade the repository URLs to HTTPS
RUN printf \
    "https://dl-cdn.alpinelinux.org/alpine/v%s/main\nhttps://dl-cdn.alpinelinux.org/alpine/v%s/community" \
    $VERSION $VERSION \
    > /etc/apk/repositories \
    && apk upgrade \
    --available \
    --no-cache \
    && rm -rf /var/cache/apk/*

CMD [ "/bin/sh" ]
