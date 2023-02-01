FROM node:16

# Set working directory
WORKDIR /app

# A wildcard is used to ensure both package.json AND package-lock.json are copied
COPY package*.json ./

RUN npm install yarn --no-package-lock && yarn && npm cache clean --force;

# Copy the contents of the project to the image
COPY . .

EXPOSE 3000

CMD ["npm", "start"]