ARG REGISTRY=docker.io
ARG ALPINE_VER=3
ARG GO_VER=1.17-alpine

FROM ${REGISTRY}/library/golang:${GO_VER} as golang
RUN apk add --no-cache \
      ca-certificates \
      git \
      make
RUN adduser -D appuser \
 && mkdir -p /home/appuser/.docker \
 && chown -R appuser /home/appuser
WORKDIR /src

FROM golang as dev
COPY . /src/
ENV PATH=${PATH}:/src/bin
CMD make bin/regbot && bin/regbot

FROM dev as build
RUN make bin/regbot
USER appuser
CMD [ "/src/bin/regbot" ]

FROM golang as docker-cred-ecr-login
ARG TARGETOS
ARG TARGETARCH
RUN go install github.com/awslabs/amazon-ecr-credential-helper/ecr-login/cli/docker-credential-ecr-login@latest \
 && ( cp "${GOPATH}/bin/docker-credential-ecr-login" /usr/local/bin/docker-credential-ecr-login \
   || cp "${GOPATH}/bin/${TARGETOS}_${TARGETARCH}/docker-credential-ecr-login" /usr/local/bin/docker-credential-ecr-login )

FROM golang as docker-cred-gcr
ARG TARGETOS
ARG TARGETARCH
RUN go install github.com/GoogleCloudPlatform/docker-credential-gcr@latest \
 && ( cp "${GOPATH}/bin/docker-credential-gcr" /usr/local/bin/docker-credential-gcr \
   || cp "${GOPATH}/bin/${TARGETOS}_${TARGETARCH}/docker-credential-gcr" /usr/local/bin/docker-credential-gcr )

FROM ${REGISTRY}/library/alpine:${ALPINE_VER} as lua-mods
RUN apk add --no-cache git \
 && mkdir -p /lua /src \
 && git clone https://github.com/grafi-tt/lunajson.git /src/json \
 && git clone https://github.com/kikito/semver.lua.git /src/semver \
 && cp -r /src/json/src/* /lua/ \
 && cp /src/semver/semver.lua /lua/ \
 && cd /lua \
 && ln -s lunajson.lua json.lua
COPY cmd/regbot/lua/ /lua/

FROM ${REGISTRY}/library/alpine:${ALPINE_VER} as release-alpine
COPY --from=build /etc/passwd /etc/group /etc/
COPY --from=build /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=build --chown=appuser /home/appuser /home/appuser
COPY --from=docker-cred-ecr-login /usr/local/bin/docker-credential-* /usr/local/bin/
COPY --from=docker-cred-gcr /usr/local/bin/docker-credential-* /usr/local/bin/
COPY --from=build /src/bin/regbot /usr/local/bin/regbot
COPY --from=lua-mods /lua /lua-mods
ENV LUA_PATH="?;?.lua;/lua-user/?;/lua-user/?.lua;/lua-mods/?;/lua-mods/?.lua"
USER appuser
CMD [ "regbot", "--help" ]

ARG BUILD_DATE
ARG VCS_REF
LABEL maintainer="" \
      org.opencontainers.image.created=$BUILD_DATE \
      org.opencontainers.image.authors="Regclient contributors" \
      org.opencontainers.image.url="https://github.com/regclient/regclient" \
      org.opencontainers.image.documentation="https://github.com/regclient/regclient" \
      org.opencontainers.image.source="https://github.com/regclient/regclient" \
      org.opencontainers.image.version="latest" \
      org.opencontainers.image.revision=$VCS_REF \
      org.opencontainers.image.vendor="" \
      org.opencontainers.image.licenses="Apache 2.0" \
      org.opencontainers.image.title="regbot" \
      org.opencontainers.image.description=""

FROM scratch as release-scratch
ADD  build/root.tgz /
COPY --from=build /etc/passwd /etc/group /etc/
COPY --from=build /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=build --chown=appuser /home/appuser /home/appuser
COPY --from=build /src/bin/regbot /regbot
COPY --from=lua-mods /lua /lua-mods
ENV LUA_PATH="?;?.lua;/lua-user/?;/lua-user/?.lua;/lua-mods/?;/lua-mods/?.lua"
USER appuser
ENTRYPOINT [ "/regbot" ]

ARG BUILD_DATE
ARG VCS_REF
LABEL maintainer="" \
      org.opencontainers.image.created=$BUILD_DATE \
      org.opencontainers.image.authors="Regclient contributors" \
      org.opencontainers.image.url="https://github.com/regclient/regclient" \
      org.opencontainers.image.documentation="https://github.com/regclient/regclient" \
      org.opencontainers.image.source="https://github.com/regclient/regclient" \
      org.opencontainers.image.version="latest" \
      org.opencontainers.image.revision=$VCS_REF \
      org.opencontainers.image.vendor="" \
      org.opencontainers.image.licenses="Apache 2.0" \
      org.opencontainers.image.title="regbot" \
      org.opencontainers.image.description=""
