FROM debian:bullseye

# Pin the version of libpcap by downloading the release directly
# (rather than installing the version from apt-get which may not be compatible)
RUN apt-get -y update && \
    apt-get install --no-install-recommends -y curl wget flex bison make build-essential && \
    curl -f -L https://github.com/Clever/gor/releases/download/v0.13.6/gor_0.13.6_x64.tar.gz | tar xvz -C /usr/local/bin/ && \
    chmod +x /usr/local/bin/gor && \
    wget https://www.tcpdump.org/release/libpcap-1.7.4.tar.gz && \
    tar xzf libpcap-1.7.4.tar.gz && \
    cd libpcap-1.7.4 && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && \
    make install && \
    cd .. && \
    rm -rf libpcap-1.7.4 && \
    apt-get install --no-install-recommends -y ca-certificates && rm libpcap-1.7.4.tar.gz && rm -rf /var/lib/apt/lists/*;

COPY bin/sfncli /usr/bin/sfncli
COPY build/linux-amd64/http-science /usr/local/bin/http-science

CMD ["/usr/bin/sfncli", "--cmd", "/usr/local/bin/http-science", "--activityname", "${_DEPLOY_ENV}--${_APP_NAME}", "--region", "us-west-2", "--cloudwatchregion", "${_POD_REGION}", "--workername", "MAGIC_ECS_TASK_ID"]
