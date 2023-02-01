FROM ubuntu:18.04

RUN apt-get update && apt-get install --no-install-recommends -y \
    build-essential \
    curl \
    git && rm -rf /var/lib/apt/lists/*;

RUN curl -f -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

WORKDIR /usr/src/indexer
COPY package.json .
COPY package-lock.json .
COPY patches patches
RUN npm install --unsafe-perm && npm cache clean --force;
# Install dependencies again to ensure all packages are installed (npm+git bug?)
RUN npm install && npm cache clean --force;
COPY . .

CMD ["npm", "start"]

EXPOSE 3005
