FROM node:12.13.0-alpine3.10
WORKDIR /root
ENV HOME /root
RUN apk add --update --no-cache bash curl g++ gcc git jq make python
RUN npm config set unsafe-perm true
RUN npm install -g npm@6.14.7 && npm cache clean --force;
RUN curl -f https://raw.githubusercontent.com/vishnubob/wait-for-it/ed77b63706ea721766a62ff22d3a251d8b4a6a30/wait-for-it.sh > /bin/wait-for && chmod +x /bin/wait-for
RUN npm install @nestjs/websockets pg redis sqlite3 && npm cache clean --force;
COPY ops ops
COPY dist dist
ENTRYPOINT ["bash", "ops/entry.sh"]
