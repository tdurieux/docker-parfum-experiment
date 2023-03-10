# Docker file

FROM    ubuntu:latest

# Git
RUN apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;

# MongoDB
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
RUN echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' | tee /etc/apt/sources.list.d/10gen.list
RUN dpkg-divert --local --rename --add /sbin/initctl
RUN ln -s /bin/true /sbin/initctl
RUN apt-get update
RUN apt-get install -y --no-install-recommends mongodb-10gen && rm -rf /var/lib/apt/lists/*;
RUN mkdir -p /data/db

# NodeJS
RUN apt-get update --fix-missing && apt-get upgrade -y
RUN apt-get install --no-install-recommends -y wget curl build-essential patch git-core openssl libssl-dev unzip ca-certificates && rm -rf /var/lib/apt/lists/*;
RUN curl -f https://nodejs.org/dist/v0.10.22/node-v0.10.22-linux-x64.tar.gz | tar xzvf - --strip-components=1 -C "/usr"
RUN apt-get clean && rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*

# Seismo
RUN git clone https://github.com/seismolabs/seismo.git /seismo
RUN cd /seismo; npm install && npm cache clean --force;
ENV PORT 8080
EXPOSE 8080

WORKDIR /seismo
ENTRYPOINT ["./bin/run-mongo.sh"]