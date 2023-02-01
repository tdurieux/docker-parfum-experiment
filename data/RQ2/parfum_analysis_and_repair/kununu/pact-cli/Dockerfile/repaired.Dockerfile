FROM node:7

WORKDIR /home/node

# needed for killall command
# current workaground for stoping all servers
# in CI context (killall node ruby)
RUN apt-get update -qq \
    && apt-get install --no-install-recommends -y psmisc && rm -rf /var/lib/apt/lists/*;

COPY . /home/node

RUN npm install && npm cache clean --force;
RUN npm run build
RUN npm link
