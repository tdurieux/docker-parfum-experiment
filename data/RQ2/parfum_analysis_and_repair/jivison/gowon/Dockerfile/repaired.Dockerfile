FROM node:16

WORKDIR /usr/src/app

# Install dependencies
COPY package*.json ./
COPY yarn.lock ./
RUN yarn && yarn cache clean;

# Copy source
COPY . .


RUN yarn rebuild && yarn cache clean;

EXPOSE 3000
CMD ["node", "dist/src/index.js"]