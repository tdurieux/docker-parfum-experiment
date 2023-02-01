FROM node:10.14.1

RUN apt-get update && apt-get install --no-install-recommends -y rsync && rm -rf /var/lib/apt/lists/*;

RUN echo 'PS1="\u@${POET_SERVICE:-noService}:\w# "' >> ~/.bashrc

RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

COPY package*.json ./
RUN npm ci

COPY . /usr/src/app/

RUN npm run build:production

CMD [ "npm", "run", "start:production" ]
