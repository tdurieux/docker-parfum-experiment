FROM node:10.18-buster
RUN apt-get update && apt-get install --no-install-recommends -y vim build-essential imagemagick ghostscript poppler-utils && rm -rf /var/lib/apt/lists/*;

# Install app dependencies
COPY package.json /tmp
RUN cd /tmp && npm install && npm cache clean --force;
RUN useradd -ms /bin/bash glampipe
RUN mkdir -p /src/app && cp -a /tmp/node_modules /src/app/
WORKDIR /src/app

# Bundle app source
COPY . /src/app/

# set permissions
RUN chown -R glampipe:glampipe /src/app && \
    mkdir /data && \
    chown -R glampipe:glampipe /data

# change user
USER glampipe

EXPOSE 3333
CMD [ "node", "glampipe.js" ]
