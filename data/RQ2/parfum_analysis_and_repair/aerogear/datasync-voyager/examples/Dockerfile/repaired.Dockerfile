FROM node:8
ARG directory
ENV EXECUTABLE_SCRIPT=$directory
WORKDIR /usr/src/app
COPY package*.json ./
COPY $directory $directory
RUN npm install && npm cache clean --force;
EXPOSE 4000
ENTRYPOINT node $EXECUTABLE_SCRIPT
