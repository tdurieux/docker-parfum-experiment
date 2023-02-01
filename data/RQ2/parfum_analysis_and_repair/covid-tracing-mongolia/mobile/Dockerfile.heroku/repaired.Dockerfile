###
# Step 1 - Load base
###
FROM gcr.io/cdssnc/covid-alert/server:latest AS base

###
# Step 2 - Build
###
FROM alpine

RUN apk add --no-cache bash

ARG PORT

WORKDIR /usr/local/bin

# Import the user and group files from step 1