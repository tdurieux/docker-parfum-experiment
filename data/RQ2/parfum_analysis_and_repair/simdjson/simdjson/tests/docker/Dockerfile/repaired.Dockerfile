FROM gcc:10
RUN echo "deb http://deb.debian.org/debian buster-backports main" >> /etc/apt/sources.list
RUN apt-get update -qq && apt-get -t buster-backports --no-install-recommends install -y cmake && rm -rf /var/lib/apt/lists/*;

