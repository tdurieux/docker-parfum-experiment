from        ubuntu
maintainer  Matthew Fisher <me@bacongobbler.com>

# install mongodb
# instructions are from http://docs.mongodb.org/manual/tutorial/install-mongodb-on-ubuntu/#install-mongodb
run         apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10
run         echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' > /etc/apt/sources.list.d/10gen.list
run apt-get update && apt-get install --no-install-recommends -q -y mongodb-10gen && rm -rf /var/lib/apt/lists/*; # hack to connect to upstart: https://github.com/dotcloud/docker/issues/1024
run         dpkg-divert --local --rename --add /sbin/initctl
run         ln -s /bin/true /sbin/initctl


# create the default data directory for mongodb
run         mkdir -p /data/db

# mongodb process
expose      27017

# mongodb admin console
expose      28017

cmd         ["mongod"]
