FROM node:alpine
RUN mkdir -p /app
WORKDIR /app
COPY . /app
RUN cd /app
RUN yarn install && yarn cache clean;
RUN yarn build
EXPOSE 3000
CMD ["node", "dist/index.js"]
