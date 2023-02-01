#
# MockServer Performance Dockerfile
#
# https://github.com/mock-server/mockserver
# http://www.mock-server.com
#

# pull base image.
FROM locustio/locust

# maintainer details
MAINTAINER James Bloom "jamesdbloom@gmail.com"

# install basic build tools
USER root
RUN apt update && apt install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;
RUN apt upgrade -y

USER locust
