FROM node:6

RUN mkdir -p /server
WORKDIR /server

COPY package.json /server/

RUN npm install && npm cache clean --force;
COPY .babelrc ./
COPY db/ ./db
COPY *.js ./
COPY models/ ./models
COPY migrations/ ./migrations
COPY client/ ./client
COPY api/ ./api

RUN npm run build

EXPOSE 5000

VOLUME db

CMD [ "npm", "start" ]