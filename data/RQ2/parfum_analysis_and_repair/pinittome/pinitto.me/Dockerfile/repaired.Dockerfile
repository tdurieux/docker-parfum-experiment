################################################################################
# Build a dockerfile for pinitto.me
# Based on ubuntu
################################################################################

FROM dockerfile/nodejs

MAINTAINER Lloyd Watkin <lloyd@evilprofessor.co.uk>

EXPOSE 3000

RUN apt-get update && apt-get install -y --no-install-recommends libcairo2-dev libjpeg8-dev libpango1.0-dev libgif-dev build-essential g++ && rm -rf /var/lib/apt/lists/*;
RUN apt-get upgrade -y


RUN git clone https://github.com/pinittome/pinitto.me.git pinitto.me
RUN cd pinitto.me && npm i . && cp contrib/docker/config.production.js . && npm cache clean --force;
ADD contrib/docker/start.sh /data/

RUN chmod +x start.sh
CMD ./start.sh