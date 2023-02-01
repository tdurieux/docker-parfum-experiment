FROM rust:latest

# Install nodejs
RUN curl -f -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get update && apt-get install -y --no-install-recommends nodejs && rm -rf /var/lib/apt/lists/*;

# Install wasm-pack
RUN curl https://rustwasm.github.io/wasm-pack/installer/init.sh -sSf | sh

WORKDIR /usr/src/conduit-wasm

COPY ./crates/conduit-wasm .

COPY .env.example .env

RUN npm install && npm cache clean --force;

EXPOSE 8000

CMD [ "npm", "start" ]
