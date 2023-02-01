FROM node:12.2.0

# Set working dir in the container to /
WORKDIR /

# Copy application to / directory and install dependencies
COPY package.json ./
RUN npm install && npm cache clean --force;
COPY . .
RUN npm run gen
# Expose port 8081 to the outside once the container has launched
EXPOSE 11047

# what should be executed when the Docker image is launching
CMD "npm run start:prod"