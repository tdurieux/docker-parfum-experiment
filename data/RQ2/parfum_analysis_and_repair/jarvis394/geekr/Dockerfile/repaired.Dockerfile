FROM node:15.2.0-alpine3.10
WORKDIR /app
COPY . .
RUN npm install && \
    npm run build && npm cache clean --force;
EXPOSE 5000
CMD npm run start:prod
