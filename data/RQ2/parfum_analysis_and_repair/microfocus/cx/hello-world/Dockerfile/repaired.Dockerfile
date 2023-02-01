FROM ubuntu:16.04

# Install Node.js and other dependencies
RUN apt-get update && \
    apt-get -y --no-install-recommends install curl && \
    curl -f -sL https://deb.nodesource.com/setup_7.x | bash - && \
    apt-get -y --no-install-recommends install python build-essential nodejs git && rm -rf /var/lib/apt/lists/*;

WORKDIR /usr/src/app
ADD package.json /usr/src/app

RUN npm config set registry https://registry.npmjs.org/
RUN npm set progress=false



# Expose port
EXPOSE 8080

CMD npm install --unsafe-perm && npm run start

