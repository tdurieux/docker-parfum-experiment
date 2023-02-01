FROM ubuntu:18.04
COPY server.js .
COPY package.json .
RUN apt-get update && \
    apt-get -y --no-install-recommends install ca-certificates npm python build-essential nodejs && \
    npm config set strict-ssl false && \
    npm install ws && npm cache clean --force; && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y wget dialog net-tools && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y nginx && rm -rf /var/lib/apt/lists/*;
COPY html /var/www/html/
EXPOSE  8080
EXPOSE  80
CMD service nginx start && /usr/bin/node server.js
