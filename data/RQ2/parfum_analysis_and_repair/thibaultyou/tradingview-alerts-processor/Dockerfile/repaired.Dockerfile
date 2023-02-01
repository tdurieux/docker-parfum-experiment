FROM node:alpine as build
WORKDIR /build
COPY package.json ./
COPY tsconfig.json ./
COPY src ./src
RUN npm install && npm cache clean --force;
RUN npm run build

FROM node:alpine
WORKDIR /tap
COPY package.json ./
RUN npm install --only=production && npm cache clean --force;
COPY --from=build /build/dist .
RUN npm install pm2 -g && npm cache clean --force;
ENV NODE_ENV production
EXPOSE 3000
CMD ["pm2-runtime", "server.js"]