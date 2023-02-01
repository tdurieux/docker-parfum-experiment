FROM node:8
COPY ./ /app
WORKDIR /app
RUN npm install && npm cache clean --force;
CMD node .
