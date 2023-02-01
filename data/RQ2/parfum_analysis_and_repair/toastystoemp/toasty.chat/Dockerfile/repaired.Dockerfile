FROM ubuntu:latest

RUN apt-get update && apt-get install --no-install-recommends -y nodejs npm git && rm -rf /var/lib/apt/lists/*;
RUN ln -s /usr/bin/nodejs /usr/bin/node
RUN mkdir /data
RUN cd /data \
&& git clone -b dockerUpdate https://github.com/ToastyStoemp/Toasty.Chat
RUN cd /data/Toasty.Chat \
&& npm install && npm cache clean --force;
RUN apt-get clean \
&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY ./entrypoint.sh /
CMD ["bash", "./entrypoint.sh"]
