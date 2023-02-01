FROM ubuntu:20.04

WORKDIR /src

# gcc g++ make
RUN \
	apt-get update && \
	apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;

# Python 3.8 and pip
RUN \
	DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y tzdata && \
	apt install --no-install-recommends -y software-properties-common && \
	add-apt-repository ppa:deadsnakes/ppa && \
	apt update && \
	apt install --no-install-recommends -y python3.8 python3-pip && rm -rf /var/lib/apt/lists/*;

# NodeJS 16.X and npm
RUN \
	apt install --no-install-recommends -y curl dirmngr apt-transport-https lsb-release ca-certificates && \
	curl -f -sL https://deb.nodesource.com/setup_16.x | bash - && \
	apt-get install --no-install-recommends -y nodejs && \
	npm install -g npm@latest && npm cache clean --force; && rm -rf /var/lib/apt/lists/*;

# Vim editor
RUN apt-get install --no-install-recommends -y vim && rm -rf /var/lib/apt/lists/*;

COPY package.json .

RUN npm install && npm cache clean --force;

COPY app app
COPY public public

EXPOSE 3010/tcp
EXPOSE 40000-40100/tcp
EXPOSE 40000-40100/udp

CMD npm start