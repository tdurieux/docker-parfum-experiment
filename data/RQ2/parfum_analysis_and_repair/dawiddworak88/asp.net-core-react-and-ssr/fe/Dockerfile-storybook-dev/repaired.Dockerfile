FROM node:12.14.1-alpine

RUN mkdir -p /home/node/aspnetcore-react-ssr/node_modules && chown -R node:node /home/node/aspnetcore-react-ssr

WORKDIR /home/node/aspnetcore-react-ssr

COPY package.json ./

COPY package-lock.json ./

USER node

RUN npm install && npm cache clean --force;

COPY --chown=node:node . .

EXPOSE 9009

CMD [ "npm", "run", "storybook" ]