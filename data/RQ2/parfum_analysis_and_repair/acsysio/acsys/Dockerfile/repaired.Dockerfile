FROM node:alpine
WORKDIR /app
COPY ./ /app
RUN npm install --legacy-peer-deps && npm cache clean --force;
RUN npm run build-linux
EXPOSE 8080
CMD ["npm", "start"]