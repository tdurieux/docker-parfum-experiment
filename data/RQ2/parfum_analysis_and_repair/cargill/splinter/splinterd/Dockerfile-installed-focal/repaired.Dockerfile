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

# -------------=== splinterd docker build ===-------------

FROM splintercommunity/splinter-dev:v11 as BUILDER

ENV SPLINTER_FORCE_PANDOC=true

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
COPY libsplinter /build/libsplinter
COPY rest_api/actix_web_1/ /build/rest_api/actix_web_1/
COPY rest_api/common/ /build/rest_api/common/
COPY splinterd/ /build/splinterd
COPY services/scabbard/libscabbard /build/services/scabbard/libscabbard

# Build splinterd
ARG REPO_VERSION
ARG CARGO_ARGS
ARG SPLINTERD_ARGS
RUN sed -i -e "0,/version.*$/ s/version.*$/version\ =\ \"${REPO_VERSION}\"/" splinterd/Cargo.toml \
 && cargo build --manifest-path=splinterd/Cargo.toml --release $CARGO_ARGS
WORKDIR /build/splinterd
RUN cargo deb --no-build --deb-version $REPO_VERSION --manifest-path ./Cargo.toml \
 && mv /build/target/debian/splinter-daemon*.deb /tmp

# Build splinter-cli
WORKDIR /build
ARG REPO_VERSION
ARG CARGO_ARGS
RUN sed -i -e "0,/version.*$/ s/version.*$/version\ =\ \"${REPO_VERSION}\"/" cli/Cargo.toml \
 && cargo build --manifest-path=cli/Cargo.toml --release $CARGO_ARGS
WORKDIR /build/cli
RUN cargo deb --no-build --deb-version $REPO_VERSION --manifest-path ./Cargo.toml \
 &&  mv /build/target/debian/splinter-cli*.deb /tmp

# Log the commit hash
COPY .git/ /tmp/.git/
WORKDIR /tmp
RUN git rev-parse HEAD > /commit-hash

# -------------=== splinterd docker build ===-------------

FROM ubuntu:focal

ARG CARGO_ARGS
RUN echo "CARGO_ARGS = '$CARGO_ARGS'" > CARGO_ARGS
ARG SPLINTERD_ARGS
RUN echo "SPLINTERD_ARGS = '$SPLINTERD_ARGS'" > SPLINTERD_ARGS

COPY --from=BUILDER /tmp/splinter-*.deb /tmp/
COPY --from=BUILDER /commit-hash /commit-hash

RUN apt-get update \
 && apt-get install -y -q --no-install-recommends \
    ca-certificates \
    man \
    postgresql-client \
 && mandb \
 && dpkg --unpack /tmp/splinter-*.deb \
 && apt-get -f -y install --no-install-recommends \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* \
 # source bash completion script at login