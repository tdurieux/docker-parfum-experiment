FROM debian:jessie-slim

RUN apt-get update --fix-missing && apt-get -y --no-install-recommends install \
    ca-certificates \
    curl \
    sudo \
    rsync && rm -rf /var/lib/apt/lists/*;

# install node.js
RUN curl -f -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
RUN sudo apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

# clean up after apt-get
RUN rm -rf /var/lib/apt/lists/* && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Change the working directory.
WORKDIR /home/distbin/app

# Install dependencies.
COPY package.json ./
COPY package-lock.json ./
RUN npm install --ignore-scripts && npm cache clean --force;

# Copy project directory.
COPY . ./

RUN npm run build

RUN mkdir -p /distbin-db/activities
RUN mkdir -p /distbin-db/inbox
# distbin will store data as files in this directory
VOLUME /distbin-db

# read by ./bin/server
ENV DB_DIR=/distbin-db

ENV PORT=80
EXPOSE 80

CMD ["npm", "start"]
