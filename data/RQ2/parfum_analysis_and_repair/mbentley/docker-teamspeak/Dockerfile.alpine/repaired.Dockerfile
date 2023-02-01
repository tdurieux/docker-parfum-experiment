# rebased/repackaged base image that only updates existing packages
FROM mbentley/alpine:latest
LABEL maintainer="Matt Bentley <mbentley@mbentley.net>"

ENV TS_DIRECTORY=/opt/teamspeak

# for cache busting
ARG TS_SERVER_VER

# install the latest teamspeak