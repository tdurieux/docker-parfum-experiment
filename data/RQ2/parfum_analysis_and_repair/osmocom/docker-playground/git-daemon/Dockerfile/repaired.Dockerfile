FROM debian:latest

ENV DEBIAN_FRONTEND noninteractive

# Install git
RUN apt-get update -qq && apt-get install --no-install-recommends -qqy git && rm -rf /var/lib/apt/lists/*;

RUN useradd -u 30001 -g ssh git-daemon

ADD git-daemon.sh /usr/bin/git-daemon.sh
VOLUME /git

# git daemon ports
EXPOSE 9418

CMD /usr/bin/git-daemon.sh
