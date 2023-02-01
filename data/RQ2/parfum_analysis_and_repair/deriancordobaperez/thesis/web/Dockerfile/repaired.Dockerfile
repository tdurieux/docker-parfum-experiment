FROM node:16-alpine

# Create app working directory
RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

# Installing dependencies
COPY package*.json ./
RUN npm install && npm cache clean --force;

# Copying source files
COPY . .

# Building app
RUN npm run build
EXPOSE 3000

# Switch node user to root
USER node

# Running the app
CMD ["npm", "start"]