FROM node:16.13.1

WORKDIR /app

COPY ./src/package.json ./
COPY ./src/package-lock.json ./

RUN npm i && npm cache clean --force;

COPY ./src/ ./

RUN npm run build

ENTRYPOINT ["npm", "run"]
CMD ["start"]