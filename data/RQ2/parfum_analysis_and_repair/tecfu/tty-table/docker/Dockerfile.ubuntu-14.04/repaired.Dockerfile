FROM ubuntu:14.04.5

# Because there is no package cache in the image, you need to run:
RUN apt-get update

# Install nodejs
RUN apt-get install --no-install-recommends curl -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends python-software-properties -y && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get update
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

# Install tty-table
RUN apt-get install --no-install-recommends git -y && rm -rf /var/lib/apt/lists/*;
RUN git clone https://www.github.com/tecfu/tty-table

# Install dev dependencies
WORKDIR /tty-table
RUN npm install && npm cache clean --force;

# Run unit tests
RUN node -v
RUN npm run test
