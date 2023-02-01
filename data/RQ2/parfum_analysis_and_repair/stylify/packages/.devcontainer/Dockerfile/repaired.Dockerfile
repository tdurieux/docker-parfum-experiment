FROM node:16

RUN apt-get update && apt-get install -y --no-install-recommends git zip unzip curl openssh-client && rm -rf /var/lib/apt/lists/*;

RUN node -v &&\
	npm -v &&\
	yarn -v

EXPOSE 82
