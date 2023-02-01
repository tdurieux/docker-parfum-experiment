FROM node:alpine
COPY ./code /code
WORKDIR /code
RUN npm install && npm cache clean --force;
EXPOSE 3000
CMD ["node", "app.js"]
