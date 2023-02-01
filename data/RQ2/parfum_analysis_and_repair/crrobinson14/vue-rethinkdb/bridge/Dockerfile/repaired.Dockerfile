FROM node:12.15.0-slim

LABEL maintainer="Jonathan Gros-Dubois"
LABEL version="16.0.1"
LABEL description="Docker file for server bridge."

RUN mkdir -p /usr/src/ && rm -rf /usr/src/
WORKDIR /usr/src/
COPY . /usr/src/

RUN npm install . && npm cache clean --force;

EXPOSE 8000

CMD ["npm", "run", "start:docker"]
