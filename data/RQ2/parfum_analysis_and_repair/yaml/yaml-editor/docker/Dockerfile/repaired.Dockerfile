FROM yamlio/alpine-runtime-all

RUN apk update && apk add --no-cache vim bash git jq

ENV PATH="/yaml-editor/bin:${PATH}"

WORKDIR /yaml/edit

