# Nametag
#
# VERSION               0.0.4

FROM node
MAINTAINER David Jay <davidgljay@gmail.com>

LABEL description="Used to start the Nametag server"
LABEL updated="7/28/17"
RUN echo "deb http://download.rethinkdb.com/apt jessie main" >> /etc/apt/sources.list
RUN echo "deb http://dl.yarnpkg.com/debian/ stable main" >> /etc/apt/sources.list
RUN wget -qO- https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN wget -qO- https://download.rethinkdb.com/apt/pubkey.gpg | apt-key add -
RUN apt-get update
RUN apt-get install --no-install-recommends yarn -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends rethinkdb -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends python-pip -y && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir rethinkdb
RUN pip install --no-cache-dir s3cmd
LABEL yarnUpdated="12/22/17"
COPY $PWD/server/package.json /usr/nametag/server/package.json
WORKDIR /usr/nametag/server
RUN yarn install && yarn cache clean;
CMD ./starthz.sh
