#docker build -t damare .

FROM node:lts-buster

RUN apt update && apt install --no-install-recommends -y vim wget open-jtalk && rm -rf /var/lib/apt/lists/*;
RUN git clone https://github.com/Chipsnet/damare.git
WORKDIR /damare
RUN yarn install && yarn cache clean;

COPY config.yml .
ENTRYPOINT ["yarn", "start"]

