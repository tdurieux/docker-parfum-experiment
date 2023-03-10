FROM node:10.15.2

WORKDIR /var/current/app

# A wildcard is used to ensure both package.json AND package-lock.json are copied
COPY package*.json ./
COPY .npmrc .npmrc
COPY local-packages local-packages
COPY scripts scripts

RUN npm install && npm cache clean --force;
RUN npm run install-packed-local
RUN rm -f .npmrc

# Bundle app source
COPY . .

CMD [ "npx", "jest", "--detectOpenHandles" ]
