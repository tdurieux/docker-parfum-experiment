# Copyright 2018-2022 Cargill Incorporated
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM splintercommunity/splinter-dev:v11 as BUILDER

# Copy over splinter files
COPY Cargo.toml /build/Cargo.toml
COPY README.md /build/README.md
COPY cli/Cargo.toml /build/cli/Cargo.toml
COPY libsplinter/build.rs /build/libsplinter/build.rs
COPY libsplinter/Cargo.toml /build/libsplinter/Cargo.toml
COPY libsplinter/protos /build/libsplinter/protos
COPY rest_api/actix_web_1/Cargo.toml /build/rest_api/actix_web_1/Cargo.toml
COPY rest_api/actix_web_4/Cargo.toml /build/rest_api/actix_web_4/Cargo.toml
COPY rest_api/common/Cargo.toml /build/rest_api/common/Cargo.toml
COPY splinterd/Cargo.toml /build/splinterd/Cargo.toml
COPY services/scabbard/cli/Cargo.toml /build/services/scabbard/cli/Cargo.toml
COPY services/scabbard/libscabbard/build.rs /build/services/scabbard/libscabbard/build.rs
COPY services/scabbard/libscabbard/Cargo.toml /build/services/scabbard/libscabbard/Cargo.toml
COPY services/scabbard/libscabbard/protos /build/services/scabbard/libscabbard/protos

# Copy over example Cargo.toml files
COPY examples/gameroom/cli/Cargo.toml \
     /build/examples/gameroom/cli/Cargo.toml
COPY examples/gameroom/daemon/Cargo.toml \
     /build/examples/gameroom/daemon/Cargo.toml
COPY examples/gameroom/database/Cargo.toml \
     /build/examples/gameroom/database/Cargo.toml

# Copy over source files

COPY cli /build/cli
COPY examples/gameroom/cli /build/examples/gameroom/cli
COPY examples/gameroom/database /build/examples/gameroom/database
COPY examples/gameroom/daemon/ /build/examples/gameroom/daemon
COPY libsplinter /build/libsplinter
COPY splinterd /build/splinterd
COPY services/scabbard/libscabbard /build/services/scabbard/libscabbard

# Build the gameroomd package
ARG REPO_VERSION
ARG CARGO_ARGS
RUN sed -i -e "0,/version.*$/ s/version.*$/version\ =\ \"${REPO_VERSION}\"/" \
    examples/gameroom/daemon/Cargo.toml \
 && cargo build --manifest-path=examples/gameroom/daemon/Cargo.toml --release $CARGO_ARGS
WORKDIR /build/examples/gameroom/daemon
RUN cargo deb --no-build --deb-version $REPO_VERSION --manifest-path ./Cargo.toml

# Build the gameroom-cli package
WORKDIR /build
ARG REPO_VERSION
ARG CARGO_ARGS
RUN sed -i -e "0,/version.*$/ s/version.*$/version\ =\ \"${REPO_VERSION}\"/" \
    examples/gameroom/cli/Cargo.toml \
 && cargo build --manifest-path=examples/gameroom/cli/Cargo.toml --release $CARGO_ARGS
WORKDIR /build/examples/gameroom/cli
RUN cargo deb --no-build --deb-version $REPO_VERSION --manifest-path ./Cargo.toml

# Build splinter-cli
WORKDIR /build
ARG REPO_VERSION
ARG CARGO_ARGS
RUN sed -i -e "0,/version.*$/ s/version.*$/version\ =\ \"${REPO_VERSION}\"/" cli/Cargo.toml \
 && cargo build --manifest-path=cli/Cargo.toml --release $CARGO_ARGS
WORKDIR /build/cli
RUN cargo deb --no-build --deb-version $REPO_VERSION --manifest-path ./Cargo.toml \
 && mv /build/target/debian/splinter-cli*.deb /tmp

# Log the commit hash
COPY .git/ /tmp/.git/
WORKDIR /tmp
RUN git rev-parse HEAD > /commit-hash

# -------------=== gameroomd docker build ===-------------
FROM ubuntu:focal

ARG CARGO_ARGS
RUN echo "CARGO_ARGS = '$CARGO_ARGS'" > CARGO_ARGS

COPY --from=BUILDER /build/target/debian/gameroom*.deb /tmp/
COPY --from=BUILDER /tmp/splinter-*.deb /tmp/
COPY --from=BUILDER /commit-hash /commit-hash

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    postgresql-client \
    unzip \
 && dpkg --unpack /tmp/gameroom*.deb \
 && dpkg --unpack /tmp/splinter*.deb \
 && apt-get -f -y install --no-install-recommends \
 && rm -r /var/lib/apt/lists/*
# Fetch the XO smart contract
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN XO_LATEST=$( curl -f --silent https://files.splinter.dev/scar/index | grep ^xo_ | tail -1) \
 && curl -f -OLsS https://files.splinter.dev/scar/"$XO_LATEST" \
 && tar -xvf xo_*.scar \
 && rm xo_*.scar \
 && mv xo-tp-rust.wasm /var/lib/gameroomd/xo-tp-rust.wasm

CMD ["gameroomd"]
