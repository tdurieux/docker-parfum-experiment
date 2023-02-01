FROM node:lts-alpine
ENV PORT 80
EXPOSE 80

WORKDIR /app
COPY package*.json ./
RUN npm install && npm cache clean --force;
COPY . .
RUN npm run build

CMD ["npm", "start"]