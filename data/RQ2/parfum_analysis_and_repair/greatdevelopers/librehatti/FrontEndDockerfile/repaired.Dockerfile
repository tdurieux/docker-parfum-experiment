FROM node:14
WORKDIR /app
COPY frontend/package*.json ./
RUN npm install && npm cache clean --force;
COPY frontend/ ./
COPY scripts/ ./
