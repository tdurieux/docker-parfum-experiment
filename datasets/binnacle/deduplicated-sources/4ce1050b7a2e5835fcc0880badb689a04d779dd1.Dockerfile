FROM ubuntu:18.04

# Because there is no package cache in the image, you need to run:
RUN apt update

# Install nodejs
RUN apt install curl gnupg -y
RUN curl -sL https://deb.nodesource.com/setup_11.x | bash -
RUN apt update
RUN apt install -y nodejs

# Install tty-table
RUN apt install git -y
RUN git clone https://www.github.com/tecfu/tty-table

# Install grunt
RUN npm install grunt-cli -g

# Install dev dependencies
WORKDIR /tty-table
RUN npm install

# Run unit tests
RUN node -v
RUN grunt t
