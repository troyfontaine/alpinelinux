FROM scratch as builder

ENV QEMU_EXECVE 1
ARG ALPINE_DOWNLOAD

ADD $ALPINE_DOWNLOAD /

COPY qemu/  /usr/bin/

RUN [ "/usr/bin/qemu-arm-static", "/bin/sh", "-c", "mv /bin/sh /bin/sh.real; ln -s /bin/sh.real /bin/sh" ]

RUN apk --update add tzdata

ENTRYPOINT [ "/usr/bin/qemu-arm-static", "/usr/bin/env", "QEMU_EXECVE=1" ]

FROM scratch

ARG ALPINE_DOWNLOAD
ARG ALPINE_VERSION
ARG BUILD_DATE
ARG VCS_REF
ARG VERSION

LABEL org.label-schema.build-date=$BUILD_DATE \
    org.label-schema.docker.dockerfile="/Dockerfile" \
    org.label-schema.license="BSD" \
    org.label-schema.name="armhf_min-alpinelinux" \
    org.label-schema.description="Minimal ARMHF Alpine Linux image" \
    org.label-schema.url="https://alpinelinux.troyfontaine.com" \
    org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.vcs-type="Git" \
    org.label-schema.vcs-url="https://github.com/troyfontaine/alpinelinux" \
    org.label-schema.docker.cmd="docker run --rm troyfontaine/armhf_min-alpinelinux:$ALPINE_VERSION [args]" \
    org.label-schema.version=$VERSION \
    org.label-schema.schema-version="1.0" \
    com.troyfontaine.architecture="ARMv7l" \
    com.troyfontaine.alpine-version=$ALPINE_VERSION \
    maintainer="Troy Fontaine"

ADD $ALPINE_DOWNLOAD /

COPY --from=builder /usr/share/zoneinfo/UTC /etc/localtime

COPY shadow /etc/shadow

ONBUILD RUN apk upgrade --available

CMD [ "/bin/sh" ]
