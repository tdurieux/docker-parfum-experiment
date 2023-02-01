#
# Build with:
# docker build --compress -t adieuadieu/chromium-for-amazonlinux-base:62.0.3202.62 --build-arg VERSION=62.0.3202.62 .
#
# Jump into the container with:
# docker run -i -t --rm --entrypoint /bin/bash  adieuadieu/chromium-for-amazonlinux-base
#
# Launch headless Chromium with:
# docker run -d --rm --name headless-chromium -p 9222:9222 adieuadieu/headless-chromium-for-aws-lambda
#

FROM amazonlinux:2.0.20200722.0-with-sources

# ref: https://chromium.googlesource.com/chromium/src.git/+refs