FROM node:10

COPY package.json /
RUN npm install axiom-cli@latest --quiet && npm cache clean --force;

COPY entry.sh /
COPY axboard.txt /

EXPOSE 3500

ENTRYPOINT /entry.sh
