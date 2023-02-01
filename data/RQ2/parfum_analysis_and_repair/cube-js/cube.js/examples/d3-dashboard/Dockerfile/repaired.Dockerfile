FROM cubejs/cube:latest

COPY package*.json ./
RUN npm install && npm cache clean --force;
COPY . .
