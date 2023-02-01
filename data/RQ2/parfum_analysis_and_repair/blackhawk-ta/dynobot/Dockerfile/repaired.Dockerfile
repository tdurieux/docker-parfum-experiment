FROM ubuntu:20.04

# Copy project
COPY ./ ./dynoBot
WORKDIR ./dynoBot

# Install dependencies
RUN apt-get update
RUN apt-get install --no-install-recommends build-essential curl -y && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get install --no-install-recommends nodejs lua5.3 -y && rm -rf /var/lib/apt/lists/*;
RUN npm install && npm cache clean --force;

# Start project
RUN npm start
