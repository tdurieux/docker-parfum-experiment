FROM node:8

WORKDIR /usr/src/app

# Install app dependencies
# A wildcard is used to ensure both package.json AND package-lock.json are
# copied where available (npm@5+)

COPY package*json ./

RUN npm install && npm cache clean --force;

## Include the app's source code
COPY . .

CMD [ "npm", "start"  ]
