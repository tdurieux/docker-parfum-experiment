FROM rust:slim AS rust

WORKDIR /rustpython

USER root
ENV USER root


RUN apt-get update && apt-get install --no-install-recommends curl libssl-dev pkg-config -y && \
  curl https://rustwasm.github.io/wasm-pack/installer/init.sh -sSf | sh && rm -rf /var/lib/apt/lists/*;

COPY . .

RUN cd wasm/lib/ && wasm-pack build --release


FROM node:alpine AS node

WORKDIR /rustpython-demo

COPY --from=rust /rustpython/wasm/lib/pkg rustpython_wasm

COPY wasm/demo .

RUN npm install && npm run dist -- --env.noWasmPack --env.rustpythonPkg=rustpython_wasm && npm cache clean --force;


FROM nginx:alpine

COPY --from=node /rustpython-demo/dist /usr/share/nginx/html
# Add the WASM mime type
RUN echo "types { application/wasm wasm; }" >>/etc/nginx/mime.types
