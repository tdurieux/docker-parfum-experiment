FROM node:6.5

WORKDIR /app
COPY package.json /app/
RUN npm install --loglevel warn && npm cache clean --force;
RUN npm config set unsafe-perm true
COPY . /app/

CMD ["npm", "test"]
