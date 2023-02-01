FROM thompsnm/nodejs-chrome
COPY . development/
WORKDIR development
RUN npm install && npm cache clean --force;
ENTRYPOINT [ "node", "index.js" ]
