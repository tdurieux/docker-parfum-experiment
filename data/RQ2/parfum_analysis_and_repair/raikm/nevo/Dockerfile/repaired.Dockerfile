FROM node:16

WORKDIR /app

COPY package*.json ./

RUN npm install && npm cache clean --force;

COPY . .

EXPOSE 8080

# CMD ["npm", "run", "vite:dev"]
CMD ["npm", "run", "vite"]
