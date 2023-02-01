FROM node:16-slim as base

WORKDIR /app
COPY package*.json ./
EXPOSE 7171

FROM base as production

RUN npm i && npm cache clean --force;
COPY . ./
RUN npm run build
CMD ["npm", "start"]
