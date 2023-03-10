FROM node:12-alpine
ENV LIBRARY_PATH=/lib:/usr/lib

RUN mkdir /bot
COPY . /bot

WORKDIR /bot

RUN apk add --no-cache --update tini && \
	npm install && \
	npm run build && \
	mkdir /config && npm cache clean --force;

ENTRYPOINT ["/sbin/tini", "--"]
CMD ["npm", "start", "--", "--config", "/config/config.json"]
