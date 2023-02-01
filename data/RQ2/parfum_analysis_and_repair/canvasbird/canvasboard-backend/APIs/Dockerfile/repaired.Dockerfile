FROM node:latest
RUN apt-get update && apt-get install -y --no-install-recommends htop && rm -rf /var/lib/apt/lists/*;
WORKDIR /app
COPY . .
RUN npm install --no-progress && npm cache clean --force;
