FROM debian:jessie

LABEL maintainer "opsxcq@strm.sh"

# Base packages
RUN apt-get update && \
    apt-get -y --no-install-recommends install \
    nginx \
    tor torsocks ntpdate && rm -rf /var/lib/apt/lists/*;

# Compile shallot
ADD ./shallot /shallot
RUN apt-get -y --no-install-recommends install \
    build-essential \
    libssl-dev && \
    cd /shallot && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && \
    make && \
    mv ./shallot /bin && \
    cd / && \
    rm -Rf /shallot && \
    apt-get -y purge build-essential libssl-dev && \
    rm -Rf /var/lib/apt/lists/*

# Security and permissions
RUN useradd --system --uid 666 -M --shell /usr/sbin/nologin hidden

# Configure nginx logs to go to Docker log collection (via stdout/stderr)
RUN ln --symbolic --force /dev/stdout /var/log/nginx/access.log
RUN ln --symbolic --force /dev/stderr /var/log/nginx/error.log

# Main script
ADD ./main.sh /main.sh

# Tor Config
ADD ./torrc /etc/tor/torrc

# Add nginx default configuration
ADD ./nginx.conf /etc/nginx/nginx.conf

# Configuration files and data output folder
VOLUME /web
WORKDIR /web

ENTRYPOINT ["/main.sh"]
CMD ["serve"]

