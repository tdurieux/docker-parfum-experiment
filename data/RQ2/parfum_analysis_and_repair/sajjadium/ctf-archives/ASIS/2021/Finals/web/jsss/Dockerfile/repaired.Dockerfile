FROM node:latest

WORKDIR /app
COPY ./stuff/index.js /app
COPY ./stuff/package.json /app
COPY ./flag.txt /
RUN npm install && npm cache clean --force;
RUN chmod +x /app/index.js
RUN useradd -m app
USER app
ENV NODE_ENV=production
CMD ["/app/index.js"]

