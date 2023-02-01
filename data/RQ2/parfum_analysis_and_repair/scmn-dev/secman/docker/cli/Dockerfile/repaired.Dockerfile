### image name: smcr/secman-cli ###

FROM debian:11

### begin ###

RUN apt-get update -y && apt-get upgrade -y
RUN apt-get install --no-install-recommends -y npm nodejs && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y curl sudo wget unzip && rm -rf /var/lib/apt/lists/*;

RUN npm i -g npm@latest && npm cache clean --force;

RUN npm i -g secman && npm cache clean --force;
RUN npm i -g @secman/scc && npm cache clean --force;

RUN secman init

ENTRYPOINT ["secman"]

### end ###
