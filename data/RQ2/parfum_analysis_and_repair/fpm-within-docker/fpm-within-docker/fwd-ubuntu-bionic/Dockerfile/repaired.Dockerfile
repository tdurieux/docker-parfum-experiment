FROM ubuntu:bionic
MAINTAINER Alan Franzoni <username@franzoni.eu>
COPY 80-acquire-retries /etc/apt/apt.conf.d/
RUN apt-get update && apt-get -y --no-install-recommends install apt-transport-https curl gnupg && rm -rf /var/lib/apt/lists/*;
RUN apt -y --no-install-recommends install ruby rubygems-integration ruby-dev build-essential rsync && rm -rf /var/lib/apt/lists/*;
RUN apt -y dist-upgrade
RUN gem install fpm -v 1.13.1
