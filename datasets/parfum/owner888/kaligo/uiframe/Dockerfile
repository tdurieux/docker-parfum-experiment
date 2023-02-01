FROM node:14.16.1-alpine
MAINTAINER fedev
ENV NODE_ENV=development
ENV HOST 0.0.0.0
RUN mkdir -p /app
COPY . /app
WORKDIR /app
EXPOSE 3000
RUN npm config set registry https://registry.npm.taobao.org
RUN npm install --silent
RUN npm run build
CMD ["npm", "start"]
