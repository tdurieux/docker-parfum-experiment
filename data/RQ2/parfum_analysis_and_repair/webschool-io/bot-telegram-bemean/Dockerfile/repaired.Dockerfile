FROM node:latest
RUN mkdir app
WORKDIR app
COPY . .
RUN npm install && npm cache clean --force;
CMD ["npm", "start"]