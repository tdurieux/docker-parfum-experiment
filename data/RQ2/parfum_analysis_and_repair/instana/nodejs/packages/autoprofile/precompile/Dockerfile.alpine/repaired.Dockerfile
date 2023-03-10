ARG BASE_IMAGE
FROM ${BASE_IMAGE}

WORKDIR /opt/autoprofile
RUN apk add --no-cache --virtual .gyp build-base python3

ENTRYPOINT ["node", "precompile/build-wrapper"]