# Node image
FROM node:10

# Create code directory
RUN mkdir /src

# Set working directory
WORKDIR /src

# Install Truffle
RUN apt-get update && apt-get -y --no-install-recommends install vim curl wget git less netcat && rm -rf /var/lib/apt/lists/*;
RUN yarn global add truffle@4 ganache-cli truffle-assertions
