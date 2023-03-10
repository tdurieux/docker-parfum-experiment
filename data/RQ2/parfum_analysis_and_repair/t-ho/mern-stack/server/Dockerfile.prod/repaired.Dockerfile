FROM node:lts-buster
WORKDIR /mern-stack/server
COPY ./server ./
# NOTE: We don't copy the .env file. Please specify env vars at runtime
RUN npm ci
CMD ["npm", "run", "prod"]