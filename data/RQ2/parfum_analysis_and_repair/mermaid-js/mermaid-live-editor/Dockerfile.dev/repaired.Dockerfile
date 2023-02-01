FROM node:18
WORKDIR /app
COPY package.json .
COPY yarn.lock .
RUN npm install && npm cache clean --force;
COPY . .
RUN ls
CMD ["yarn", "dev"]