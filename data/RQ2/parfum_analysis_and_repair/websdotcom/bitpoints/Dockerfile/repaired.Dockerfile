FROM node:4.2.0

EXPOSE 80
ENV NODE_ENV production

COPY package.json ./
RUN npm install && npm cache clean --force;
COPY . .

CMD ["npm", "start"]
