FROM node:8

RUN apt-get update -qq && apt-get install --no-install-recommends -y emacs && rm -rf /var/lib/apt/lists/*;

WORKDIR /iD

COPY ./iD /iD

RUN npm install && npm cache clean --force;

EXPOSE 8080

RUN npm run all

CMD [ "npm", "start" ]
