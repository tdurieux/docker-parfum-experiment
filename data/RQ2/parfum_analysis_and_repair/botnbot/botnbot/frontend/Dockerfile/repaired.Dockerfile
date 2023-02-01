FROM debian:buster-slim

# curl
RUN \
 apt-get update && \
 apt-get install --no-install-recommends -y sudo gnupg curl xz-utils git && rm -rf /var/lib/apt/lists/*;

# node
RUN curl -f -sL https://deb.nodesource.com/setup_14.x | sudo -E bash - && \
 sudo apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

# Copy app
ENV APP_HOME /myapp
RUN mkdir $APP_HOME
WORKDIR $APP_HOME
COPY . $APP_HOME

# build app
RUN npm install && npm cache clean --force;
RUN npm run build:prod

# clean
RUN apt-get purge -y curl git gnupg

EXPOSE 8081
CMD ["npm", "run", "serve"]
