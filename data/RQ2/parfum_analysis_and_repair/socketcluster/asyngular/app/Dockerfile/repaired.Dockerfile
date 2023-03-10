FROM node:10-slim

LABEL maintainer="Jonathan Gros-Dubois"
LABEL version="6.1.1"
LABEL description="Docker file for Asyngular with support for clustering."

RUN mkdir -p /usr/src/ && rm -rf /usr/src/
WORKDIR /usr/src/
COPY . /usr/src/

RUN npm install . && npm cache clean --force;

EXPOSE 8000

CMD ["npm", "run", "start:docker"]
