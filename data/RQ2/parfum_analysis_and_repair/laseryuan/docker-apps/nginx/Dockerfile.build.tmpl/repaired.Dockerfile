FROM {{ARCH.images.build_base}}

ENV LANG C.UTF-8
ENV LD_LIBRARY_PATH=/usr/local/lib

RUN apt-get -y update && apt-get install --no-install-recommends -y \
    curl build-essential make gcc libpcre3 libpcre3-dev libpcre++-dev zlib1g-dev libbz2-dev libxslt1-dev libxml2-dev libgd2-xpm-dev libgeoip-dev libgoogle-perftools-dev libperl-dev libssl-dev libcurl4-openssl-dev && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y \
      ca-certificates && rm -rf /var/lib/apt/lists/*;
