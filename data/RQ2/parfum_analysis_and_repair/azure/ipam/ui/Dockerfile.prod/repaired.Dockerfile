FROM node:16-slim

# Set Working Directory
WORKDIR /app

# Add `/app/node_modules/.bin` to $PATH
ENV PATH /app/node_modules/.bin:$PATH

# Copy Node Package Files
COPY package.json ./
COPY package-lock.json ./

# Install Dependencies
RUN npm install && npm cache clean --force;

# Copy Application Code
COPY . ./

# Build Application
RUN npm run build

# Expose Port
EXPOSE 80

# Inject ENV Variables & Start Server
CMD npx --yes react-inject-env set && npx --yes http-server -a 0.0.0.0 -P http://localhost? -p 80 build
