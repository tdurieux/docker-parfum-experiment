FROM node:14.17-stretch-slim
WORKDIR /app
COPY ./ .
RUN rm -rf node_modules
RUN npm install && npm cache clean --force;

RUN apt-get update && apt-get install --no-install-recommends -y wait-for-it && rm -rf /var/lib/apt/lists/*;

EXPOSE 3000
CMD ["npm", "start"]
