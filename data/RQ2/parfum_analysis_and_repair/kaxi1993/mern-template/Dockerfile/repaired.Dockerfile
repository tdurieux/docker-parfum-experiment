FROM kaxi1993/ubuntu

# Create app directory
RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

# Install app dependencies
COPY package*.json ./
RUN npm install && npm cache clean --force;

# Bundle app source
COPY . .

# Run APP
EXPOSE 5000
CMD ["pm2-docker", "process.json", "--only", "production"]
