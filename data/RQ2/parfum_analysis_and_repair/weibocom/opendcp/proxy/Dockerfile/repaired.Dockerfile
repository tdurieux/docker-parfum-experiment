FROM nginx:latest

RUN apt-get update
RUN apt-get install --no-install-recommends -y php5-common php5-cli php5-fpm php5-mysql php5-dev redis-server vim && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libapache2-mod-php5 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y php5-ldap php5-curl && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y rsync && rm -rf /var/lib/apt/lists/*;

ADD ./phpredis /phpredis
WORKDIR /phpredis
RUN phpize
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"
RUN make && make install

WORKDIR /
ADD ./run.sh run.sh

ENTRYPOINT ["./run.sh"]
