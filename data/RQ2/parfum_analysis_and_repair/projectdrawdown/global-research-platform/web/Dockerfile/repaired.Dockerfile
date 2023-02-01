FROM node:14-alpine

WORKDIR /app     

# Copy package.json ke /app
COPY package*.json ./

# Copy project
COPY . .

# Install dependencies
RUN npm install && npm cache clean --force;

# Port public untuk akses
EXPOSE 3000

# Run development server
CMD [ "npm", "run", "start"]