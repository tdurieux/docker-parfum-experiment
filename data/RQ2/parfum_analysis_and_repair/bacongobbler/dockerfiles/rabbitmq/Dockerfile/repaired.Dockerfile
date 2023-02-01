from        ubuntu
maintainer  Matthew Fisher <me@bacongobbler.com>

# install prerequisites
run apt-get update && apt-get install --no-install-recommends -q -y wget erlang-nox logrotate && rm -rf /var/lib/apt/lists/*;

# hack to connect to upstart: https://github.com/dotcloud/docker/issues/1024
run         dpkg-divert --local --rename --add /sbin/initctl

# add rabbitmq to sources
run wget --quiet https://www.rabbitmq.com/releases/rabbitmq-server/v3.1.3/rabbitmq-server_3.1.3-1_all.deb
run         dpkg -i rabbitmq-server_3.1.3-1_all.deb

# cleanup install
run         rm rabbitmq-server_3.1.3-1_all.deb

expose      5672

cmd         ["rabbitmq-server"]
