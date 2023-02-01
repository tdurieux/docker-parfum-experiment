FROM node:lts
WORKDIR .
COPY package*.json .
RUN npm install --no-save && npm cache clean --force;
RUN npm install -g pm2 && npm cache clean --force;
COPY . .
EXPOSE [[PORT]]
CMD ["pm2-runtime", "./server/index.js"]
