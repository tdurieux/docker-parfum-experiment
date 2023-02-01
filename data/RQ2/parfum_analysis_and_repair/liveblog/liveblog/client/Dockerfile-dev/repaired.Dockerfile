# import base image
FROM dockerfile/nodejs

# install system-wide dependencies
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y libfreetype6 libfontconfig && \
    npm -g install grunt-cli && npm cache clean --force; && rm -rf /var/lib/apt/lists/*;

# setup the environment
WORKDIR	/opt/superdesk-client/
EXPOSE	9000
CMD ["grunt"]

# install app-wide dependencies
COPY ./package.json /opt/superdesk-client/
RUN npm install && npm cache clean --force;

# copy sources
COPY . /opt/superdesk-client
