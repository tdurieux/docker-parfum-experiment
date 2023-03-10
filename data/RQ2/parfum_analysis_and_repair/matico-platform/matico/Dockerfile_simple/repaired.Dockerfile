# For building the server and the spec
#----------------------------------------------------------------------------------
FROM osgeo/gdal:ubuntu-small-3.4.1 as rust-builder
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs -o install_rust.sh
RUN sh install_rust.sh -y
ENV PATH="/root/.cargo/bin/:${PATH}"

RUN rustup default nightly
RUN apt-get update && apt-get -y --no-install-recommends install libpq-dev build-essential pkg-config openssl libssl-dev libclang-dev && rm -rf /var/lib/apt/lists/*; # RUN apt-get -y install software-properties-common
# RUN add-apt-repository ppa:nextgis/ppa && apt-get update

# RUN apk --no-cache add g++ make libressl-dev pkgconfig

RUN curl https://rustwasm.github.io/wasm-pack/installer/init.sh -sSf | sh

RUN mkdir /app
ADD ./Cargo.toml ./Cargo.toml /app/
ADD ./matico_spec /app/matico_spec
ADD ./matico_spec_derive /app/matico_spec_derive
ADD ./matico_server /app/matico_server

WORKDIR /app
RUN ls
RUN cargo build --release


WORKDIR /app/matico_spec
RUN wasm-pack build  --release
RUN sed -i 's/\"matico_spec\"/\"@maticoapp\/matico_spec"/g' pkg/package.json

# Install the dependencies for javascript
#--------------------------------------------------------------------------------

FROM node:16.6.1-alpine3.13 as javascript_deps
ENV NODE_ENV production
RUN apk add --no-cache libc6-compat

WORKDIR /app

ADD . .
COPY --from=rust-builder /app/matico_spec/pkg /app/matico_spec/pkg
RUN yarn
RUN yarn workspace @maticoapp/matico_components build-prod && yarn cache clean;

