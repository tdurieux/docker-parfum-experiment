FROM node:10

WORKDIR /home/app
RUN npm install -g lerna && npm cache clean --force;
COPY . .
RUN lerna bootstrap --hoist && lerna run build
EXPOSE 8545

CMD ["npm", "run", "localchain:test"]
