FROM node:argon

USER root
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install --no-install-recommends -y libicu-dev && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN npm install -g teleirc && npm cache clear --force

RUN useradd -ms /bin/bash teleirc
USER teleirc

RUN mkdir -p /home/teleirc/.teleirc
VOLUME ["/home/teleirc/.teleirc"]

EXPOSE 9090

CMD ["teleirc"]

