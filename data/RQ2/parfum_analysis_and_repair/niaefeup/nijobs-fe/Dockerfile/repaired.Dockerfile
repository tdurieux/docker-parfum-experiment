FROM node:14.18.3-alpine

RUN mkdir -p /usr/src/nijobs-fe && rm -rf /usr/src/nijobs-fe
WORKDIR /usr/src/nijobs-fe

COPY package*.json ./

RUN npm install && npm cache clean --force;

# Necessary files for building the app
COPY public/ public/
COPY config/ config/
COPY scripts/ scripts/
COPY src/ src/

# Copy env files
COPY .env* ./

EXPOSE $PORT

CMD ["npm", "start"]