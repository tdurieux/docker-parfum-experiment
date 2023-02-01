FROM arm32v7/node:9
#setup for web server that will serve api as well as static bundled react

RUN apt-get update && \
    apt-get -y --no-install-recommends install curl && \
    apt-get -y --no-install-recommends install python build-essential && rm -rf /var/lib/apt/lists/*;

RUN npm install serve-static && npm cache clean --force;

#first copy package and install dependencies
WORKDIR /usr/src/fullcyclereact/src/api/
COPY src/api/package*.json ./
RUN npm install && npm cache clean --force;

#then copy api source
COPY src/api/. .

WORKDIR /usr/src/fullcyclereact/src/web/
COPY src/web/package*.json ./
RUN npm install && npm cache clean --force;
#RUN npm install @material-ui/icons
#RUN npm install --save @fortawesome/react-fontawesome

#then copy web source and build it, bundled output in build dir
COPY src/web/. .
RUN npm run build

WORKDIR /usr/src/fullcyclereact/src/api

EXPOSE 3000

#serve up express api with static build content
CMD npm run prod
