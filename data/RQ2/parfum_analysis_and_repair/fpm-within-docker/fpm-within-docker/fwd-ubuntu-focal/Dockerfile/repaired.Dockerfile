FROM ubuntu:focal
MAINTAINER Alan Franzoni <username@franzoni.eu>
COPY 80-acquire-retries /etc/apt/apt.conf.d/
RUN apt-get update && apt-get -y --no-install-recommends install apt-transport-https curl gnupg ruby rubygems-integration ruby-dev build-essential rsync && apt -y dist-upgrade && rm -rf /var/lib/apt/lists/*;
RUN gem install fpm -v 1.13.1
