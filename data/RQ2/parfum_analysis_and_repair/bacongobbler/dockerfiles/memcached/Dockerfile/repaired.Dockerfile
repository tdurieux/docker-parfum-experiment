from        ubuntu
maintainer  Matthew Fisher <me@bacongobbler.com>

run apt-get update && apt-get install --no-install-recommends -q -y memcached && rm -rf /var/lib/apt/lists/*;

expose      11211

cmd         ["memcached", "-u", "daemon"]
