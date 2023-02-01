FROM debian:11

ARG FTP_UPLOAD_PWD=""
ARG FTP_UPLOAD_USER=""
ARG FTP_UPLOAD_PATH=""
ARG HTTP_CHECK_PATH=""
ARG SX_BRANCH="master"
ARG CURL_UPLOAD_OPTS=""
ARG MAKE_DEBUG="Y"

WORKDIR /app

RUN if [ "$http_proxy" != "" ]; then echo "Acquire::http { Proxy \"${http_proxy}\"; };" >> /etc/apt/apt.conf.d/01proxy; fi;

RUN apt update && apt -y --no-install-recommends install git && DEBIAN_FRONTEND=noninteractive apt --no-install-recommends install -y tzdata && rm -rf /var/lib/apt/lists/*;

RUN echo "Getting git branch: ${SX_BRANCH}"; git clone --depth 1 --recursive https://github.com/astibal/smithproxy.git -b ${SX_BRANCH} smithproxy

RUN cd smithproxy && ./tools/linux-deps.sh

RUN cd /app/smithproxy/tools/pkg-scripts/deb && ./createdeb-0.9.sh

CMD echo "there is nothing to see - it's a build-only image"