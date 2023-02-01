FROM drupalci/db-base
MAINTAINER drupalci

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10

RUN echo "deb http://repo.mongodb.org/apt/ubuntu "$(lsb_release -sc)"/mongodb-org/3.0 multiverse" > /etc/apt/sources.list.d/mongodb-org-3.0.list

RUN apt-get update && apt-get install --no-install-recommends -y adduser mongodb-org-server mongodb-org-shell && rm -rf /var/lib/apt/lists/*;
RUN mkdir -p /data/db



CMD ["mongod"]

EXPOSE 27017
