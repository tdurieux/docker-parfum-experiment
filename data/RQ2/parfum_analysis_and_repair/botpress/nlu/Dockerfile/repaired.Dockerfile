FROM node:12.13.1

ADD . /nlu

WORKDIR /nlu

RUN apt update && \
	apt install --no-install-recommends -y wget ca-certificates && rm -rf /var/lib/apt/lists/*;

RUN yarn && yarn cache clean;

RUN yarn build && yarn cache clean;

ENTRYPOINT ["yarn", "start"]
