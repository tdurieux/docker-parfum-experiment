FROM alanfranz/fpm-within-docker:debian-jessie
MAINTAINER Alan Franzoni <username@franzoni.eu>
RUN apt-get update ; apt-get -y --no-install-recommends install python wget && rm -rf /var/lib/apt/lists/*;
