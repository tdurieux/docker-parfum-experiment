# needed for serve to work
FROM node:8.11.4

# set / create working directory
WORKDIR /app

# Install yarn
RUN apt-get update && apt-get install --no-install-recommends -y apt-transport-https && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install -y --no-install-recommends yarn && rm -rf /var/lib/apt/lists/*;

# add `/app/node_modules/.bin` to $PATH
ENV PATH /app/node_modules/.bin:$PATH

# needed for build script to work
COPY . .
RUN yarn install && yarn cache clean;
RUN yarn run build

EXPOSE 3000

CMD ["yarn", "start"]