# swoft/alphp:cli:
# @description php 7.1 image base on the alpine 3.7
# ------------------------------------------------------------------------------------
# @link https://hub.docker.com/_/alpine/      alpine image
# @link https://hub.docker.com/_/php/         php image
# @link https://github.com/docker-library/php php dockerfiles
# ------------------------------------------------------------------------------------
# @build-example docker build . -f Dockerfile -t scil/swoole:app1
#

FROM swoft/alphp:cli
LABEL maintainer="scil" version="1.0"

##
# ---------- building ----------
##