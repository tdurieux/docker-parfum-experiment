################################################################################
# Build a dockerfile for buddycloud-http-api
# Based on ubuntu
################################################################################

FROM dockerfile/nodejs

MAINTAINER Lloyd Watkin <lloyd@evilprofessor.co.uk>

EXPOSE 9123

RUN apt-get update && apt-get install -y --no-install-recommends git git-core libicu-dev libexpat-dev build-essential libssl-dev build-essential g++ && rm -rf /var/lib/apt/lists/*;
RUN apt-get upgrade -y


RUN git clone https://github.com/buddycloud/buddycloud-http-api.git api-server
RUN cd api-server && git checkout master
RUN cd api-server && npm i . && cp contrib/docker/config.js . && npm cache clean --force;
ADD contrib/docker/start.sh /data/

RUN chmod +x start.sh
CMD ./start.sh
