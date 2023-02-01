FROM node:lts-alpine
RUN npm install -g http-server && npm cache clean --force;
WORKDIR /app/frontend
COPY package*.json ./
RUN npm install --production && npm cache clean --force;
COPY . .
RUN npm run build
CMD ["http-server", "dist", "-p", "3000"]
