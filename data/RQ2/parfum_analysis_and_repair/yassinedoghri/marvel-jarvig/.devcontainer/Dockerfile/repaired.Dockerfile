ARG VARIANT="16-bullseye"
FROM node:${VARIANT}

RUN npm install -g npm@latest \
    && npm install -g yarn --force && npm cache clean --force;
