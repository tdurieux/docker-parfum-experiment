FROM node:16.14.2-bullseye

USER node

COPY fonts/ /usr/local/share/fonts/

WORKDIR /home/node

COPY --chown=node:node . .

RUN npm install --workspaces && npm cache clean --force;

ENV NODE_ENV=production

RUN npm run build --workspaces \
    && rm -rf node_modules \
    && npm install --production --workspaces && npm cache clean --force;

EXPOSE 3000

CMD [ "node", "dist/index.js" ]
