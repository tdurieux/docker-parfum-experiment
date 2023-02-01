FROM node:14

RUN apt-get update && apt-get install --no-install-recommends -y \
	libcairo2-dev \
	libjpeg-dev \
	libpango1.0-dev \
	libgif-dev \
	libpng-dev \
	build-essential \
	g++ && rm -rf /var/lib/apt/lists/*;

WORKDIR /usr/src/app
COPY package*.json ./
RUN npm ci
COPY . .
