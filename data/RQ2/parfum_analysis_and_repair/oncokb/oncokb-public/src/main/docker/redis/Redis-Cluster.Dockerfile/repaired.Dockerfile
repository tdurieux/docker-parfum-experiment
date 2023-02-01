FROM redis:6.0.4
RUN apt update && \
    apt install --no-install-recommends dnsutils -y && rm -rf /var/lib/apt/lists/*;
ADD redis/connectRedisCluster.sh /usr/local/bin/connectRedisCluster
RUN chmod 755 /usr/local/bin/connectRedisCluster
ENTRYPOINT ["connectRedisCluster"]
