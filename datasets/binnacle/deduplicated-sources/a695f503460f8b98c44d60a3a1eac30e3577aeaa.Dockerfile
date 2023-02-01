## Build plugin
ARG KONG_VERSION
FROM kong:${KONG_VERSION} as builder

RUN apk --no-cache add zip
WORKDIR /tmp

COPY ./*.rockspec /tmp
COPY ./LICENSE /tmp/LICENSE
COPY ./src /tmp/src
ARG PLUGIN_VERSION
RUN luarocks make && luarocks pack kong-plugin-jwt-keycloak ${PLUGIN_VERSION}

## Create Image
FROM kong:${KONG_VERSION}

ENV KONG_PLUGINS="bundled,jwt-keycloak"

COPY --from=builder /tmp/*.rock /tmp/

ARG PLUGIN_VERSION
RUN luarocks install /tmp/kong-plugin-jwt-keycloak-${PLUGIN_VERSION}.all.rock && rm /tmp/*