FROM stackbrew/ubuntu:12.04
MAINTAINER Matt Bentley <mbentley@mbentley.net>
RUN (echo "deb http://archive.ubuntu.com/ubuntu/ precise main restricted universe multiverse" > /etc/apt/sources.list && echo "deb http://archive.ubuntu.com/ubuntu/ precise-updates main restricted universe multiverse" >> /etc/apt/sources.list && echo "deb http://archive.ubuntu.com/ubuntu/ precise-backports main restricted universe multiverse" >> /etc/apt/sources.list && echo "deb http://archive.ubuntu.com/ubuntu/ precise-security main restricted universe multiverse" >> /etc/apt/sources.list)
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y curl && rm -rf /var/lib/apt/lists/*;
RUN curl -f https://get.docker.io/builds/Linux/x86_64/docker-latest -o /usr/local/bin/docker
RUN chmod +x /usr/local/bin/docker
ADD run.sh /usr/local/bin/run
ENTRYPOINT ["/usr/local/bin/run"]
