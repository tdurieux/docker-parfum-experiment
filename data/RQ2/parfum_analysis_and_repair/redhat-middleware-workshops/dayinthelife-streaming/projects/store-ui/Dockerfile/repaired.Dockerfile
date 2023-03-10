FROM node:10-alpine

COPY package*.json ./

RUN npm install && npm cache clean --force;

COPY . .

# Build frontend JS assets
RUN npm run build

# Remove our "devDependencies" since they're required for build, but not runtime
RUN npm prune --production

EXPOSE 8080

CMD [ "npm", "start" ]

