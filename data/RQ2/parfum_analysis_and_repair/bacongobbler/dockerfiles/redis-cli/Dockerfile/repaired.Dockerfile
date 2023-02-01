from        ubuntu
maintainer  Matthew Fisher <me@bacongobbler.com>

run apt-get update && apt-get install --no-install-recommends -yq git build-essential tcl8.5 && rm -rf /var/lib/apt/lists/*;

# install redis CLI
run git clone -b v2.8.7 https://github.com/antirez/redis.git
run cd redis && make install redis-cli /usr/bin

entrypoint  ["redis-cli"]
