FROM node:13.8
COPY package.json /package.json
COPY package-lock.json /package-lock.json
RUN npm install && npm cache clean --force;
COPY . /
RUN npm run build
RUN npm install -g serve && npm cache clean --force;
CMD ["serve", "dist"]
