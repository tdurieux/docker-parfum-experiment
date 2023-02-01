# Pull base image.
FROM library/ubuntu

# TODO
# Change maintainer to LABEL and add all authors
MAINTAINER Ronald Eddings <ronaldeddings@gmail.com>

RUN apt-get update

#
# Python
#
RUN apt-get install --no-install-recommends -y python python-dev python-pip python-virtualenv git && rm -rf /var/lib/apt/lists/*;

#
# Node.js and NPM
#
RUN apt-get install -y nodejs nodejs-legacy npm git --no-install-recommends && rm -rf /var/lib/apt/lists/*;
RUN ln -s /dev/null /dev/raw1394

#
# Install dependencies required by node-canvas
#
RUN apt-get install --no-install-recommends -y libcairo2-dev libjpeg8-dev libpango1.0-dev libgif-dev build-essential g++ sudo && rm -rf /var/lib/apt/lists/*;

# Create app directory
RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

RUN git clone https://github.com/apg-intel/ipv6tools.git
WORKDIR /usr/src/app/ipv6tools
RUN git checkout dev

# Install project dependencies
RUN npm run setup

EXPOSE 8080

# Start Project
CMD [ "npm", "run", "start" ]

#
# Clear cache
#
RUN apt-get autoclean && apt-get clean
RUN rm -rf /var/lib/apt/lists/*
