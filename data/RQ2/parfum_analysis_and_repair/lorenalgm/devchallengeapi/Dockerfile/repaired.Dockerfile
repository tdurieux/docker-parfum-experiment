FROM node:alpine

WORKDIR /app

COPY package.json .

RUN npm install && npm cache clean --force;
# RUN npm install --only=production

COPY . .

ENV NODE_ENV=development
# ENV NODE_ENV=production

ENV MONGO_URL=mongodb://mongodb/devchallenge-${NODE_ENV}
ENV PORT=3333

EXPOSE ${PORT}

ENTRYPOINT ["npm", "run", "dev"]
# ENTRYPOINT ["npm", "start"]
