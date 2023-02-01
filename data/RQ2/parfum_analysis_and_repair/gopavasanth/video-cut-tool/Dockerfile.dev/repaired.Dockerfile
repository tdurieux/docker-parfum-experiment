# Install node
FROM node:14

# Install FFMPEG library
RUN apt update -y && apt install --no-install-recommends ffmpeg -y && rm -rf /var/lib/apt/lists/*;

# Set the workdir /app
WORKDIR /app

# Frontend
# Copy the package.json to workdir
COPY package.json ./
COPY server/package.json ./server/
COPY server/package-lock.json ./server


# Run npm install - install the npm dependencies
RUN npm install --legacy-peer-deps && npm cache clean --force;

RUN cd server && npm install --legacy-peer-deps && npm cache clean --force;

# Copy application source
COPY . .

EXPOSE 3000 4000 8081

# Start the application
CMD ["npm", "run", "dev"]
