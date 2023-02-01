FROM node
COPY package.json .
RUN npm install && npm cache clean --force;
COPY . .
CMD [ "npm" , "run", "start"]
