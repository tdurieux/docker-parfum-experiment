FROM node:argon

# Install required prereqs.
RUN apt-get -y update && apt-get -y --no-install-recommends install netcat && rm -rf /var/lib/apt/lists/*;

# Create app directory
RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

# Update npm
RUN npm install -g npm && npm cache clean --force;

# Install app dependencies
COPY package.json /usr/src/app/
RUN npm install --quiet && npm cache clean --force;

# Bundle app source
COPY . /usr/src/app

CMD ["sh", "./Scripts/docker-startup.sh"]

# Expose the port.
EXPOSE 8080
