FROM ubuntu:18.04

RUN apt-get update -qq \
  && apt-get install -y --no-install-recommends -qq curl openjdk-8-jre-headless nodejs npm libsodium23 systemd nano \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /home/rnode/

RUN npm i -g npm -q && npm cache clean --force;

COPY scripts/* scripts/

RUN bash scripts/install -q

COPY app app/
RUN cd app && npm install -q && npm cache clean --force;

RUN cd app && mkdir -p evaluations
RUN cd app && touch evaluations/output.log

COPY config .rnode/
RUN touch .rnode/rnode.log

RUN chmod -R 777 /home/rnode/

EXPOSE 40402

CMD ["bash", "scripts/start"]
