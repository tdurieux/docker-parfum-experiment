FROM ubuntu:18.04

# Because there is no package cache in the image, you need to run:
RUN apt update

# Install nodejs
RUN apt install --no-install-recommends curl gnupg -y && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sL https://deb.nodesource.com/setup_11.x | bash -
RUN apt update
RUN apt install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

# Install tty-table
RUN apt install --no-install-recommends git -y && rm -rf /var/lib/apt/lists/*;
RUN git clone https://www.github.com/tecfu/tty-table

# Install dev dependencies
WORKDIR /tty-table
RUN npm install && npm cache clean --force;

# Run unit tests & report coverage
RUN node -v
# RUN npx mocha
RUN npm run coverage
RUN npm run report-to-coverio
RUN npm run report-to-coveralls
