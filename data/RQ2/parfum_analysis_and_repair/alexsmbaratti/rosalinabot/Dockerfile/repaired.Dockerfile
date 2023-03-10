FROM node:8.10.0

LABEL description="RosalinaBot"

# Set Environment Variables
ENV NODE_VERSION=8.10.0
ENV PLATFORM="Docker"
ENV TIMEZONE=America/Los_Angeles
# Make sure to set TOKEN env with command line!

USER root

WORKDIR /app

RUN ln -snf /usr/share/zoneinfo/$TIMEZONE /etc/localtime && echo $TIMEZONE > /etc/timezone

# Install dev tools
RUN apt-get -y update && apt-get -y --no-install-recommends install wget nano npm curl mongodb ca-certificates rsync git && rm -rf /var/lib/apt/lists/*;

# Copy Repository
COPY package.json /app
COPY . /app

# Install dependencies
RUN npm install && npm cache clean --force;

# Run RosalinaBot
CMD node app.js