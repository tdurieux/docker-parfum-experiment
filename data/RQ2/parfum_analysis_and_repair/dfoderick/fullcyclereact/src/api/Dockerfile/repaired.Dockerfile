#this docker currently not used see /src/Dockerfile

FROM arm32v7/node:9

# Install Node.js and other dependencies
RUN apt-get update && \
    apt-get -y --no-install-recommends install curl && \
    apt-get -y --no-install-recommends install python build-essential && rm -rf /var/lib/apt/lists/*;
RUN npm install -g nodemon && npm cache clean --force;

#first copy package and install dependencies
WORKDIR /usr/src/fullcyclereact/src/api/
COPY package*.json ./
RUN npm install && npm cache clean --force;

#then copy source
COPY . .

EXPOSE 5000

CMD npm run prod
