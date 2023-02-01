FROM heroku/heroku:20

# NodeJS
RUN curl -f -sL https://deb.nodesource.com/setup_14.x | bash - && \
    curl -f -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update -y && apt-get install --no-install-recommends -y nodejs gcc g++ make yarn && rm -rf /var/lib/apt/lists/*;

RUN node --version
RUN yarn --version

WORKDIR /usr/src/app

# Install Dependencies
COPY . .
RUN yarn install --skip-builds && yarn cache clean;

# Build Server
RUN yarn workspace server build && yarn cache clean;

CMD ["node", "./server/dist/index.js"]