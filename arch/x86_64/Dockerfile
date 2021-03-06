from scratch as builder
ADD alpine.tgz /

RUN apk --update add tzdata

FROM scratch

ARG ALPINE_VERSION
ARG BUILD_DATE
ARG VCS_REF
ARG VERSION

ADD alpine.tgz /

LABEL org.label-schema.build-date=$BUILD_DATE \
    org.label-schema.docker.dockerfile="/Dockerfile" \
    org.label-schema.license="BSD" \
    org.label-schema.name="x86_64-alpinelinux" \
    org.label-schema.description="x86_64 Alpine Linux image" \
    org.label-schema.url="https://alpinelinux.troyfontaine.com" \
    org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.vcs-type="Git" \
    org.label-schema.vcs-url="https://github.com/troyfontaine/alpinelinux" \
    org.label-schema.docker.cmd="docker run --rm troyfontaine/x86_64-alpinelinux:$ALPINE_VERSION [args]" \
    org.label-schema.version=$VERSION \
    org.label-schema.schema-version="1.0" \
    com.troyfontaine.architecture="x86_64" \
    com.troyfontaine.alpine-version=$ALPINE_VERSION \
    maintainer="Troy Fontaine"

COPY --from=builder /usr/share/zoneinfo/UTC /etc/localtime

COPY shadow /etc/shadow

ONBUILD RUN apk upgrade --available

CMD [ "/bin/sh" ]
