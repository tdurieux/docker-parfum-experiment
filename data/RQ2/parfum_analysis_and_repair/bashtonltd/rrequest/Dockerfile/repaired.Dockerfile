FROM ubuntu:12.04
MAINTAINER David Watson <david@bashton.com>

# Install required packages
RUN apt-get update
RUN apt-get install --no-install-recommends -qq -y python-software-properties software-properties-common curl git build-essential && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository ppa:chris-lea/node.js
RUN apt-get update
RUN apt-get install --no-install-recommends -qq -y nodejs && rm -rf /var/lib/apt/lists/*;
RUN curl -f https://install.meteor.com | /bin/sh
RUN npm install --silent -g forever meteorite && npm cache clean --force;

# Add rrequest source
ADD . /rrequest-source

# Bundle app
RUN cp -r /rrequest-source /rrequest-build && cd /rrequest-build && mrt install && meteor bundle --directory /rrequest

# Cleanup bundle
WORKDIR /rrequest
RUN rm -r programs/server/node_modules/fibers && npm install fibers@1.0.1 && npm cache clean --force;

# Expose port
EXPOSE 3000

# Run app
RUN touch .foreverignore
CMD forever ./main.js
