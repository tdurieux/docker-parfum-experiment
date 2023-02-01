FROM ubuntu:16.04

# Update ubuntu and install dependencies
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install --no-install-recommends -y curl apt-transport-https && rm -rf /var/lib/apt/lists/*;

# Install nodejs
RUN curl -f -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get install --no-install-recommends -y nodejs build-essential && rm -rf /var/lib/apt/lists/*;

# Install mongodb
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2930ADAE8CAF5059EE73BB4B58712A2291FA4AD5
RUN echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.6 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-3.6.list
RUN apt-get update
RUN apt-get install --no-install-recommends -y mongodb-org-tools && rm -rf /var/lib/apt/lists/*;

WORKDIR /app

COPY package.json /app

RUN npm install && npm cache clean --force;

COPY . /app

RUN npm run build

CMD node dist/src/bin/online-service.js --microservice backup
