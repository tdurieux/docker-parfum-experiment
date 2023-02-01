#this docker currently not used see /src/Dockerfile

FROM arm32v7/node:9

RUN apt-get update && \
    apt-get -y --no-install-recommends install curl && \
    apt-get -y --no-install-recommends install python build-essential && rm -rf /var/lib/apt/lists/*;
RUN npm install -g nodemon && npm cache clean --force;
RUN npm install -g serve && npm cache clean --force;

#first copy just the package and install dependencies
WORKDIR /usr/src/fullcyclereact/src/web/
COPY package*.json ./
RUN npm install && npm cache clean --force;
RUN npm install material-ui@next && npm cache clean --force;

#then copy source
COPY . .
RUN npm run build

EXPOSE 3000

#CMD npm run start
CMD serve -p 3000 build
