from ubuntu:14.04

ENV DEBIAN_FRONTEND=noninteractive

run apt-get update && apt-get -y upgrade
run apt-get install --no-install-recommends -y vim curl tmux php5-fpm && rm -rf /var/lib/apt/lists/*;
run curl -f https://getcaddy.com | bash

EXPOSE 2015
