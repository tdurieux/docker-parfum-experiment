FROM --platform=$BUILDPLATFORM golang:1.17.7-alpine AS bld
ARG TARGETPLATFORM
ARG TARGETARCH
ARG TARGETVARIANT
ARG BUILDPLATFORM
RUN apk add --no-cache bash git
RUN mkdir /manifest-tool
WORKDIR /manifest-tool
COPY  . /manifest-tool
RUN /manifest-tool/hack/makestatic.sh $TARGETARCH ${TARGETVARIANT#v}

FROM scratch
COPY --from=bld /manifest-tool/manifest-tool /manifest-tool
COPY --from=bld /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
ENTRYPOINT [ "/manifest-tool" ]
