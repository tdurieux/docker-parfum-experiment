FROM node
WORKDIR /server
COPY package.json /server
COPY package-lock.json /server
RUN npm install && npm cache clean --force;
COPY . /server
CMD ["npm", "run", "start"]