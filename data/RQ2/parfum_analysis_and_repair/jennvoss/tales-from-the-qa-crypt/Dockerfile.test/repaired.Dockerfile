FROM cypress/base:10 as test
WORKDIR /app
COPY package*.json /app/
RUN npm install && npm cache clean --force;
RUN $(npm bin)/cypress verify
