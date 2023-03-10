FROM kylef/swiftenv

RUN swiftenv install 3.0-GM-CANDIDATE

# install redis
RUN cd /tmp && curl -f -O http://download.redis.io/redis-stable.tar.gz && tar xzvf redis-stable.tar.gz >/dev/null 2>&1 && cd redis-stable && make >/dev/null 2>&1 && make install && rm redis-stable.tar.gz

# install libssl and graphviz
RUN apt-get update && apt-get install --no-install-recommends -y libssl-dev graphviz && rm -rf /var/lib/apt/lists/*;

WORKDIR /package
VOLUME /package
EXPOSE 8080

# mount in local sources via:  -v $(PWD):/package

CMD redis-server ./Redis/redis.conf && swift build && .build/debug/swiftpm-dependency-fetcher
