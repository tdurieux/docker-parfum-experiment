# gives a docker image below 200 MB
FROM node:10

ENV NODE_ENV "qa"
ENV PORT 3000
EXPOSE 3000
# create local user to avoid running as root
RUN addgroup mygroup
RUN useradd -ms /bin/bash myuser
RUN mkdir -p /usr/src/app && chown -R myuser /usr/src/app && rm -rf /usr/src/app
RUN apt update && apt install --no-install-recommends -y rabbitmq-server && rm -rf /var/lib/apt/lists/*;
# Prepare app directory
WORKDIR /usr/src/app
COPY package.json /usr/src/app/
# RUN npm config set -g production false
# USER myuser
# Install our packages
RUN npm install && npm cache clean --force;
RUN npm install mocha && npm cache clean --force;

#  patch for loopback-component-passport
# RUN sed -i "s|relations: modelDefinition.relations,|relations: modelDefinition.relations,acls: modelDefinition.acls|" node_modules/loopback-component-passport/lib/index.js

# Copy the rest of our application, node_modules is ignored via .dockerignore
COPY . /usr/src/app
COPY CI/PSI/envfiles/config.local.js /usr/src/app/server/
COPY CI/PSI/envfiles/providers.json /usr/src/app/server/
COPY CI/PSI/envfiles/datasources.json /usr/src/app/server/
COPY CI/PSI/component-config.json /usr/src/app/server/
COPY CI/PSI/envfiles/settings.json /usr/src/app/test/config/
COPY CI/PSI/start.sh /usr/src/app/start.sh
# Start the app
RUN cat /usr/src/app/server/datasources.json
RUN echo "Running startup script"
CMD ./start.sh
