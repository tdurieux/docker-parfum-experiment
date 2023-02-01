######################################
# Prepare npm_builder
######################################
FROM node:16 as npm_builder
WORKDIR /go/src/github.com/openflagr/flagr
ADD . .
ARG FLAGR_UI_POSSIBLE_ENTITY_TYPES=null
ENV VUE_APP_FLAGR_UI_POSSIBLE_ENTITY_TYPES ${FLAGR_UI_POSSIBLE_ENTITY_TYPES}
RUN make build_ui

######################################
# Prepare go_builder
######################################
FROM golang:1.17 as go_builder
WORKDIR /go/src/github.com/openflagr/flagr
ADD . .
RUN make build

######################################
# Copy from builder to alpine image
######################################