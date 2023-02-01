# Inherit from Heroku's stack
FROM heroku/cedar:14
MAINTAINER pirhoo <hello@pirhoo.com>

# Internally, we arbitrarily use port 3000
ENV PORT 3000
# Which version of node?
ENV NODE_ENGINE 5.7.1
ENV NODE_ENV production
ENV ENV production
# Locate our binaries
ENV PATH /app/heroku/node/bin/:/app/user/node_modules/.bin:$PATH

# Create some needed directories
RUN mkdir -p /app/heroku/node /app/.profile.d
WORKDIR /app/user

RUN apt-get update
RUN apt-get install --no-install-recommends -y build-essential libssl-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libcairo2-dev libjpeg8-dev libpango1.0-dev libgif-dev g++ && rm -rf /var/lib/apt/lists/*;

# Install node
RUN curl -f -s https://s3pository.heroku.com/node/v$NODE_ENGINE/node-v$NODE_ENGINE-linux-x64.tar.gz | tar --strip-components=1 -xz -C /app/heroku/node

# Export the node path in .profile.d
RUN echo "export PATH=\"/app/heroku/node/bin:/app/user/node_modules/.bin:\$PATH\"" > /app/.profile.d/nodejs.sh

ADD dist /app/user
RUN /app/heroku/node/bin/npm install

CMD ["node", "server/app.js"]
