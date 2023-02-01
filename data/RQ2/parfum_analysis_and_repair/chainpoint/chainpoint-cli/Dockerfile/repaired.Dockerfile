FROM node:8.17.0-jessie-slim

RUN apt-get update -y
RUN apt-get install --no-install-recommends -y curl make g++ git apt-transport-https ca-certificates python && rm -rf /var/lib/apt/lists/*;

RUN curl -f -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update -y && apt-get install -y --no-install-recommends yarn && rm -rf /var/lib/apt/lists/*;

WORKDIR /
RUN cd / && git clone https://github.com/chainpoint/chainpoint-cli.git
RUN cd /chainpoint-cli && git checkout origin/proof-v4 && yarn && yarn run build && yarn cache clean;
RUN ls /chainpoint-cli/build
CMD ["/chainpoint-cli/build/chainpoint-cli-linux"]

