FROM node:carbon

RUN \
	set -x \
	&& apt-get update \
	&& apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /code
WORKDIR /code
COPY . /code

RUN npm install && npm cache clean --force;

CMD ["npm", "start"]

