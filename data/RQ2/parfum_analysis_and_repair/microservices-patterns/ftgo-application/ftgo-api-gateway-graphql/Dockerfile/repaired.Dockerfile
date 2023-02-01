FROM node:9.11.2-alpine
COPY package.json .
COPY package-lock.json .
RUN npm install && npm cache clean --force;
RUN npm config set unsafe-perm true && npm install -g typescript && npm cache clean --force;
COPY tsconfig.json .
ADD src ./src
RUN npm run build
CMD npm run start
