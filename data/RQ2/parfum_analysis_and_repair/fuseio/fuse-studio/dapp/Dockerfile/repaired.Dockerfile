FROM node:latest
USER $UID:$GID
WORKDIR /app
RUN apt install -y --no-install-recommends git && rm -rf /var/lib/apt/lists/*;
COPY package*.json ./
RUN npm install && npm cache clean --force;
COPY . .
CMD ["npm", "start"]