# Build
FROM node:14.15.4 as builder
WORKDIR /app

COPY . ./
RUN npm install && npm cache clean --force;

EXPOSE 3001
CMD ["npm", "run", "test"]
