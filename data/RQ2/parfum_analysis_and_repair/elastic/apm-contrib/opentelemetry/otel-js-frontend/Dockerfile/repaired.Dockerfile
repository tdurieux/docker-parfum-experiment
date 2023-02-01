FROM node:12

WORKDIR /app
ADD . /app
RUN npm install && npm cache clean --force;
CMD ["node", "-r", "./tracing.js", "app.js"]

