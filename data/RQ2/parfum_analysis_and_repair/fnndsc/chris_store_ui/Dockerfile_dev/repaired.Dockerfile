#
# Docker file for ChRIS store ui development server
#
# Build with
#
#   docker build -t <name>:<tag> -f <dockerfile> .
#
# For example if building a local version, you could do:
#
#   docker build -t local/chris_store_ui:dev -f Dockerfile_dev .
#
# In the case of a proxy (located at say 10.41.13.4:3128), do:
#
#    export PROXY="http://10.41.13.4:3128"
#    docker build --build-arg http_proxy=${PROXY} --build-arg UID=$UID -t local/chris_store_ui:dev -f Dockerfile_dev .
#
# To run the server up during development, do:
#
#   docker run --rm -it -v $(pwd):/home/localuser -p 3000:3000 -u $(id -u):$(id -g) --name chris_store_ui local/chris_store_ui:dev
#
# To run an interactive shell inside this container, do:
#
#   docker exec -it chris_store_ui sh
#

FROM node:12-alpine
MAINTAINER fnndsc "dev@babymri.org"

# Pass a UID on build command line (see above) to set internal UID
ARG UID=1001
ENV UID=$UID  HOME="/home/localuser" VERSION="0.1"

RUN apk add --no-cache git           \
  && adduser -u $UID -D localuser

# Start as user localuser