######################################
# Prepare npm_builder
######################################
FROM node:10 as npm_builder
WORKDIR /go/src/github.com/checkr/flagr
ADD . .
ARG FLAGR_UI_POSSIBLE_ENTITY_TYPES=null
ENV VUE_APP_FLAGR_UI_POSSIBLE_ENTITY_TYPES ${FLAGR_UI_POSSIBLE_ENTITY_TYPES}
RUN make build_ui

######################################
# Prepare go_builder
######################################
FROM golang:1.16 as go_builder
WORKDIR /go/src/github.com/checkr/flagr
ADD . .
RUN make build

######################################
# Copy from builder to alpine image
######################################