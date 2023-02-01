# Install node
FROM node:16 as build

# Install FFMPEG library
RUN apt update -y && apt install --no-install-recommends ffmpeg -y && rm -rf /var/lib/apt/lists/*;

# Set the workdir /app
WORKDIR /app

# Frontend
# Copy the package.json to workdir
COPY package.json ./
COPY server/package.json ./server/

# Install dependncies
RUN npm install --legacy-peer-deps && npm cache clean --force;

# Copy application source
COPY . .

EXPOSE 80 4000

# run express server
# RUN node server/index.js
CMD ["npm", "run", "prd"]

# Build
RUN npm run build

# Run ngnix server
FROM nginx:1.21.4 as server
COPY --from=build /app/build /usr/share/nginx/html
