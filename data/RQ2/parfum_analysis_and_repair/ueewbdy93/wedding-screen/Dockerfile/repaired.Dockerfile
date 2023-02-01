FROM node:10

RUN apt update && \
	apt install --no-install-recommends -y software-properties-common ca-certificates && \
	apt update && \
	apt install --no-install-recommends -y graphicsmagick && rm -rf /var/lib/apt/lists/*;

WORKDIR /usr/src/app
EXPOSE 5566
COPY . .
COPY ./src/config/config.sample.json ./src/config/config.json

RUN npm install && \
	npm run build && \
	npm prune --production && npm cache clean --force;

ENV BUILD_IMAGE=Y
ENV TITLE="Happy Wedding"
VOLUME ["/usr/src/app/dist/config", "/usr/src/app/db", "/usr/src/app/src/public/images"]
CMD ["utils/docker-adapter.sh"]
