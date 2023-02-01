# Use an official Ubuntu Xenial as a parent image
FROM ubuntu:latest

# Install Node.js 8 and npm 5
RUN apt-get update
RUN apt-get -qq update
RUN apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sL https://deb.nodesource.com/setup_8.x | bash
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

# Set the working directory to /app
WORKDIR /home

# Copy the current directory contents into the container
ADD . /home

# Install any needed packages specified in requirements.txt
RUN npm install -g ganache-cli truffle && npm cache clean --force;
RUN npm install && npm cache clean --force;

# Make port 8080 available outside this container
EXPOSE 8080
EXPOSE 8545