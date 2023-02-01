FROM node:alpine
WORKDIR "/app"
COPY . .
WORKDIR "/app/shared"
RUN npm install && npm cache clean --force;
WORKDIR "/app/priceHistory"
RUN npm ci
RUN npm run build
CMD ["npm", "run", "start"]
