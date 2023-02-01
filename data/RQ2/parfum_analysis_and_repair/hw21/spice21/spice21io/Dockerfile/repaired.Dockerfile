# Rust + Node Image

# Start from the official Rust image
FROM rust:latest

# And add Node & Yarn Pre-reqs
RUN apt -y update && \
    apt -y upgrade && \
    apt -y --no-install-recommends install curl dirmngr apt-transport-https lsb-release ca-certificates && curl -f -sL https://deb.nodesource.com/setup_14.x | bash && \
    apt -y --no-install-recommends install nodejs && \
    node --version && \
    npm --version && \
    curl -f -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt -y update && \
    apt -y --no-install-recommends install yarn && \
    yarn --version && rm -rf /var/lib/apt/lists/*;

# Create a user to run this thing, rather than `root`
RUN useradd --create-home dummy
USER dummy
WORKDIR /home/dummy

# Copy local code to the container image.
COPY --chown=dummy:dummy . ./

# Build and install Spice21 core, JS bindings, and server 
RUN cd spice21js && \
    yarn install && yarn protoc && \
    cd ../spice21io && \
    yarn install --production && \
    cd .. && yarn cache clean;

# Run the server on startup
CMD [ "node", "spice21io/index.js" ]
