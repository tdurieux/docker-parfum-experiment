FROM node:alpine

ENV NODE_ENV production

WORKDIR /app
ADD . .

EXPOSE 3000
RUN npm install && npm cache clean --force;
CMD ["npm", "start"]