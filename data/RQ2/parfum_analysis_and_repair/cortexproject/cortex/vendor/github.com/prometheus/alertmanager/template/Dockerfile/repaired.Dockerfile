FROM node

ENV NODE_PATH="/usr/local/lib/node_modules"

RUN npm install juice -g && npm cache clean --force;

ENTRYPOINT [""]
