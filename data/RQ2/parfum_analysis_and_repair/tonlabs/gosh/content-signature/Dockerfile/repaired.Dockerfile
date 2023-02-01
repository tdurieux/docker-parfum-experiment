FROM node:latest

WORKDIR /app
COPY . /app
RUN npm i && npm -g i typescript && tsc && npm cache clean --force;
ENTRYPOINT [ "node", "cli" ]
CMD [ "--help" ]
