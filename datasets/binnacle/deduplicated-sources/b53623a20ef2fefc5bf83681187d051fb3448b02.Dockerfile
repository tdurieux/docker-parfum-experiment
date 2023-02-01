FROM ubuntu:14.04.5

# Because there is no package cache in the image, you need to run:
RUN apt-get update

# Install nodejs
RUN apt-get install curl -y
RUN apt-get install python-software-properties -y
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get update
RUN apt-get install -y nodejs

# Install tty-table
RUN apt-get install git -y
RUN git clone https://www.github.com/tecfu/tty-table

# Install grunt
RUN npm install grunt-cli -g

# Install dev dependencies
WORKDIR /tty-table
RUN npm install

# Run unit tests
RUN node -v
RUN grunt t
