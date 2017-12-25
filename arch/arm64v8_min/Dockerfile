FROM scratch as builder

ENV QEMU_EXECVE 1

ADD alpine.tgz /

COPY qemu/  /usr/bin/

RUN [ "/usr/bin/qemu-aarch64-static", "/bin/sh", "-c", "mv /bin/sh /bin/sh.real; ln -s /bin/sh.real /bin/sh" ]

RUN [ "cross-build-start" ]

RUN apk --update add tzdata

RUN [ "cross-build-end" ]

FROM scratch

ARG ALPINE_VERSION
ARG BUILD_DATE
ARG VCS_REF
ARG VERSION

LABEL org.label-schema.build-date=$BUILD_DATE \
    org.label-schema.docker.dockerfile="/Dockerfile" \
    org.label-schema.license="BSD" \
    org.label-schema.name="armhf-alpinelinux" \
    org.label-schema.description="Minimal ARM64v8 Alpine Linux image" \
    org.label-schema.url="https://alpinelinux.troyfontaine.com" \
    org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.vcs-type="Git" \
    org.label-schema.vcs-url="https://github.com/troyfontaine/alpinelinux" \
    org.label-schema.docker.cmd="docker run --rm troyfontaine/arm64v8_min-alpinelinux:$ALPINE_VERSION [args]" \
    org.label-schema.version=$VERSION \
    org.label-schema.schema-version="1.0" \
    com.troyfontaine.architecture="ARM64v8" \
    com.troyfontaine.alpine-version=$ALPINE_VERSION \
    maintainer="Troy Fontaine"

ADD alpine.tgz /

COPY --from=builder /usr/share/zoneinfo/UTC /etc/localtime

COPY shadow /etc/shadow

ONBUILD RUN apk upgrade --available

CMD [ "/bin/sh" ]
