FROM node:10-alpine
ENV NODE_ENV production
WORKDIR /app
COPY . .
RUN npm install && npm cache clean --force;
EXPOSE 3000
CMD npm start
