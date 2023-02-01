FROM node:latest
WORKDIR /usr/src/app
COPY /server/package*.json ./
RUN npm install && npm cache clean --force;
RUN npm i -g nodemon && npm cache clean --force;
COPY /server .
RUN cd .. && mkdir bin
COPY /docker/bin/wait-for-it.sh ../bin
RUN ["chmod", "+x", "../bin/wait-for-it.sh"]