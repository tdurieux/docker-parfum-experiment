FROM node:6.9

RUN npm install -g gulp && npm cache clean --force;

WORKDIR /source
COPY package.json .
RUN npm install && npm cache clean --force;

ENTRYPOINT ["gulp"]
CMD ["default"]
