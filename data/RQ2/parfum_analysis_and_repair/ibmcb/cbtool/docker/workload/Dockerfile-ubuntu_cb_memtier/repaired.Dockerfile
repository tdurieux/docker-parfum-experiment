FROM REPLACE_NULLWORKLOAD_UBUNTU

# autoreconf-install-pm
RUN apt-get update
RUN apt-get install --no-install-recommends -y build-essential autoconf automake libpcre3-dev zlib1g-dev libtool pkg-config && rm -rf /var/lib/apt/lists/*;
# autoreconf-install-pm

# redis-install-pm
RUN apt-get install --no-install-recommends -y redis-server && rm -rf /var/lib/apt/lists/*;
RUN sed -i "s/.*bind.*/bind 0.0.0.0/" /etc/redis/redis.conf
# service_stop_disable redis-server
# redis-install-pm

# memtier_benchmark-install-man
RUN apt-get update; apt-get install --no-install-recommends -y libevent-dev && rm -rf /var/lib/apt/lists/*;
RUN /bin/true; cd /home/REPLACE_USERNAME; git clone https://github.com/RedisLabs/memtier_benchmark.git
RUN /bin/true; cd /home/REPLACE_USERNAME/memtier_benchmark/; export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:${PKG_CONFIG_PATH}; autoreconf -ivf; ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"; make
RUN /bin/true; cd /home/REPLACE_USERNAME/memtier_benchmark/; sudo make install
# memtier_benchmark-install-man
RUN chown -R REPLACE_USERNAME:REPLACE_USERNAME /home/REPLACE_USERNAME
