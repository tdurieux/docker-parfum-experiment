# -------------------------------------------------
# This Docker image contains all the typical
# runtime dependencies for thumbsup, including
# exiftool, imagemagick, ffmpeg, gifsicle...
# -------------------------------------------------

ARG NODE_VERSION
FROM node:${NODE_VERSION}-alpine as base

# Metadata
LABEL org.opencontainers.image.source https://github.com/thumbsup/thumbsup

# Add libraries
RUN apk add --update --no-cache libgomp zlib libpng libjpeg-turbo libwebp tiff lcms2 x265 libde265 libheif

# Add external programs