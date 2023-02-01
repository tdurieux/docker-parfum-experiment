FROM node:8
MAINTAINER Mario Behling <mb@mariobehling.de>

RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

RUN apt-get update && apt-get clean && rm -rf /var/lib/apt/lists/*

# install deps
RUN apt-get install -y --no-install-recommends curl && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sL https://deb.nodesource.com/setup_8.x | bash
RUN apt-get install -y --no-install-recommends nodejs && apt-get clean -y && rm -rf /var/lib/apt/lists/*;

# copy requirements
COPY package.json /usr/src/app/
COPY app.json /usr/src/app/
COPY tslint.json /usr/src/app/
COPY angular-cli.json /usr/src/app/

# Bundle app source
COPY . /usr/src/app

# install requirements
RUN npm install -g @angular/cli@latest && npm cache clean --force;
RUN npm install && npm cache clean --force;

EXPOSE 4200

CMD ["ng", "serve"]
