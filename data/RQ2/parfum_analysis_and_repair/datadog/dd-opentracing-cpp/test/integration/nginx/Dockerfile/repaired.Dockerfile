# Creates an image with nginx and the Datadog OpenTracing nginx module installed.
# Runs a simple integration test.
ARG NGINX_VERSION=1.18.0
ARG OPENTRACING_NGINX_VERSION=0.16.0

# The nginx testbed. Build this image first since we don't want it rebuilt if just the code changes.
FROM ubuntu:20.04 as nginx-testbed

# Prevent installation of "tzdata" from blocking for input.
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
  apt-get install --no-install-recommends -y git gnupg lsb-release wget curl tar openjdk-8-jre golang jq iproute2 && rm -rf /var/lib/apt/lists/*;

# Get Wiremock
RUN wget https://repo1.maven.org/maven2/com/github/tomakehurst/wiremock-standalone/2.18.0/wiremock-standalone-2.18.0.jar -O wiremock-standalone-2.18.0.jar
RUN printf '#!/bin/bash\nset -x\njava -jar '"$(pwd)/wiremock-standalone-2.18.0.jar \"\$@\"\n" > /usr/local/bin/wiremock && \
  chmod a+x /usr/local/bin/wiremock

ARG NGINX_VERSION

# Install nginx
RUN CODENAME=$(lsb_release -s -c) && \
  wget https://nginx.org/keys/nginx_signing.key && \
  apt-key add nginx_signing.key && \
  echo deb https://nginx.org/packages/ubuntu/ ${CODENAME} nginx >> /etc/apt/sources.list && \
  echo deb-src https://nginx.org/packages/ubuntu/ ${CODENAME} nginx >> /etc/apt/sources.list && \
  apt-get update && \
  apt-get install -y --no-install-recommends nginx=${NGINX_VERSION}-1~${CODENAME} && rm -rf /var/lib/apt/lists/*;

# Install nginx-opentracing
ARG OPENTRACING_NGINX_VERSION
RUN wget https://github.com/opentracing-contrib/nginx-opentracing/releases/download/v${OPENTRACING_NGINX_VERSION}/linux-amd64-nginx-${NGINX_VERSION}-ot16-ngx_http_module.so.tgz && \
  NGINX_MODULES=$(nginx -V 2>&1 | grep "configure arguments" | sed -n 's/.*--modules-path=\([^ ]*\).*/\1/p') && \
  tar zxvf linux-amd64-nginx-${NGINX_VERSION}-ot16-ngx_http_module.so.tgz -C "${NGINX_MODULES}" && rm linux-amd64-nginx-${NGINX_VERSION}-ot16-ngx_http_module.so.tgz

# Build the Datadog nginx module.
FROM ubuntu:20.04 as build

# Prevent installation of "tzdata" from blocking for input.
ENV DEBIAN_FRONTEND=noninteractive

ENV CFLAGS="-march=x86-64 -fPIC"
ENV CXXFLAGS="-march=x86-64 -fPIC"
ENV LDFLAGS="-fPIC"


RUN apt-get update && \
  apt-get install --no-install-recommends -y git build-essential wget curl tar cmake libpcre3-dev && rm -rf /var/lib/apt/lists/*;

WORKDIR /root

COPY ./scripts ./dd-opentracing-cpp/scripts
RUN cd dd-opentracing-cpp && \
  ./scripts/install_dependencies.sh
COPY ./3rd_party ./dd-opentracing-cpp/3rd_party
COPY ./include ./dd-opentracing-cpp/include
COPY ./src ./dd-opentracing-cpp/src
COPY ./CMakeLists.txt ./dd-opentracing-cpp/CMakeLists.txt
RUN rm -rf dd-opentracing-cpp/.build
RUN mkdir -p dd-opentracing-cpp/.build
WORKDIR dd-opentracing-cpp/.build
RUN cmake -DBUILD_PLUGIN=ON -DBUILD_STATIC=OFF -DBUILD_TESTING=OFF -DBUILD_SHARED=OFF -DCMAKE_BUILD_TYPE=RelWithDebInfo ..
RUN make "-j${MAKE_JOB_COUNT:-$(nproc)}"
RUN make install
WORKDIR ..

# Build the final testbed.
FROM nginx-testbed

# Install Datadog OpenTracing
COPY --from=build /root/dd-opentracing-cpp/.build/libdd_opentracing_plugin.so /usr/local/lib/libdd_opentracing_plugin.so

# Add OpenTracing directives to nginx config
COPY ./test/integration/nginx/nginx.conf /tmp/nginx.conf
RUN NGINX_CONF=$(nginx -V 2>&1 | grep "configure arguments" | sed -n 's/.*--conf-path=\([^ ]*\).*/\1/p') && \
  mv /tmp/nginx.conf ${NGINX_CONF}
COPY ./test/integration/nginx/dd-config.json /etc/dd-config.json
RUN mkdir -p /var/www/
COPY ./test/integration/nginx/index.html /var/www/index.html

# TODO(cgilmour): Hack to pin a dep of msgpack-cli
RUN git clone -b v1.1.2 https://github.com/ugorji/go /root/go/src/github.com/ugorji/go
RUN go get github.com/jakm/msgpack-cli
# Copy these last so that edits don't need as many image rebuild steps
COPY ./test/integration/nginx/nginx_integration_test.sh ./
COPY ./test/integration/nginx/expected_*.json ./
CMD [ "bash", "-x", "./nginx_integration_test.sh"]
