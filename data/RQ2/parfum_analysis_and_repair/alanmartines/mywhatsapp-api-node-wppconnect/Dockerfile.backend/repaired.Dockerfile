FROM node:16.14-slim

LABEL version="1.0.0" description="ApiWPPconnect" maintainer="Alan Martines<alancpmartines@hotmail.com>"

RUN mkdir -p /home/ApiWPPconnect
RUN mkdir -p /usr/local/tokens
RUN chmod -R 777 /usr/local/tokens/

RUN apt-get update && \
	apt-get upgrade -y && \
	apt-get install --no-install-recommends -y \
	git \
	curl \
	yarn \
	gcc \
	g++ \
	make \
	libgbm-dev \
	wget \
	unzip \
	fontconfig \
	locales \
	apt-utils \
	gconf-service \
	libasound2 \
	libatk1.0-0 \
	libc6 \
	libcairo2 \
	libcups2 \
	libdbus-1-3 \
	libexpat1 \
	libfontconfig1 \
	libgconf-2-4 \
	libgdk-pixbuf2.0-0 \
	libglib2.0-0 \
	libgtk-3-0 \
	libnspr4 \
	libpango-1.0-0 \
	libpangocairo-1.0-0 \
	libstdc++6 \
	libx11-6 \
	libx11-xcb1 \
	libxcb1 \
	libxcomposite1 \
	libxcursor1 \
	libxdamage1 \
	libxext6 \
	libxfixes3 \
	libxi6 \
	libxrandr2 \
	libxrender1 \
	libxss1 \
	libxtst6 \
	# mysql-client \
	ca-certificates \
	fonts-liberation \
	libnss3 \
	lsb-release \
	xdg-utils \
	libatk-bridge2.0-0 \
	libgbm1 \
	libgcc1 \
	build-essential \
	nodejs \
	#libappindicator1 \
	sudo && \
	apt-get autoremove -y && rm -rf /var/lib/apt/lists/*;

RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
	&& apt-get install --no-install-recommends -y ./google-chrome-stable_current_amd64.deb \
	&& rm -fr ./google-chrome-stable_current_amd64.deb && rm -rf /var/lib/apt/lists/*;

RUN apt-get update \
	&& apt-get upgrade -y

RUN npm install -g npm@latest && npm cache clean --force;

WORKDIR /home/ApiWPPConnect

EXPOSE 9001/tcp

CMD [ "node", "--trace-warnings", "server.js" ]

## Acessar bash do container
# docker exec -it <container id> /bin/sh
# docker exec -it <container id> /bin/bash

## Logs do container
# docker logs -f --tail 1000 ApiWPPconnect

## Removendo todos os containers e imagens de uma só vez
# docker rm $(docker ps -qa)

## Removendo todas as imagens de uma só vez
# docker rmi $(docker images -aq)

## Removendo imagens
# docker rmi <REPOSITORY>
# docker rmi <IMAGE ID>

## Como obter o endereço IP de um contêiner Docker do host
# https://stack.desenvolvedor.expert/appendix/docker/rede.html
# docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' <IMAGE ID>
