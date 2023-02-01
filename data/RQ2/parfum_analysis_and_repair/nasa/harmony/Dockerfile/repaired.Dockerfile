ARG BASE_IMAGE=node:16-buster
FROM $BASE_IMAGE
RUN apt update && apt-get install -y --no-install-recommends sqlite3 && rm -rf /var/lib/apt/lists/*;
RUN mkdir -p /harmony
COPY package.json package-lock.json lerna.json /harmony/
RUN chown node -R /harmony
USER node
WORKDIR /harmony
RUN npm ci
RUN npm install sqlite3 --save && npm cache clean --force;
COPY . /harmony/
# build the sqlite dabase
USER root
RUN ./bin/create-database development
RUN chown -R node db
USER node
ENTRYPOINT [ "npm", "run", "start" ]