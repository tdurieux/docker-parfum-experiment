###########################################
###             Build Stage             ###
###########################################
FROM alpine:3.15.4 AS builder
COPY scripts/build_modjk.sh /build/build.sh
WORKDIR /build
RUN set -ex \
    && chmod +x ./build.sh \
    && ./build.sh

###########################################
###          Container Stage            ###
###########################################