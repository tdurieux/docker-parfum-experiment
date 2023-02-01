FROM ubuntu:14.04

RUN apt-get -y update && apt-get -y --no-install-recommends install \
  curl \
  wget && rm -rf /var/lib/apt/lists/*;

# https://www.nginx.com/resources/admin-guide/installing-nginx-open-source/
RUN apt-get -y --no-install-recommends install build-essential && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install libpcre3 libpcre3-dev zlib1g-dev libssl-dev && rm -rf /var/lib/apt/lists/*;

ADD headers-more-nginx-module /headers-more-nginx-module

RUN wget https://nginx.org/download/nginx-1.10.2.tar.gz
RUN tar zxf nginx-1.10.2.tar.gz && cd nginx-1.10.2 && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/etc/nginx --sbin-path=/usr/sbin/nginx --conf-path=/etc/nginx/nginx.conf --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log --pid-path=/var/run/nginx.pid --lock-path=/var/run/nginx.lock --add-module=/headers-more-nginx-module && make && sudo make install && rm nginx-1.10.2.tar.gz

EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]
