FROM rust:1.34.1

RUN addgroup --gid 1000 maidsafe && \
    adduser --uid 1000 --ingroup maidsafe --home /home/maidsafe --shell /bin/sh --disabled-password --gecos "" maidsafe && \
    # The parent container sets this to the 'staff' group, which causes problems
    # with reading code stored in Cargo's registry.
    chgrp -R maidsafe /usr/local

# Install fixuid for dealing with permissions issues with mounted volumes.
# We could perhaps put this into a base container at a later stage.
RUN USER=maidsafe && \
    GROUP=maidsafe && \
    curl -SsL https://github.com/boxboat/fixuid/releases/download/v0.4/fixuid-0.4-linux-amd64.tar.gz | tar -C /usr/local/bin -xzf - && \
    chown root:root /usr/local/bin/fixuid && \
    chmod 4755 /usr/local/bin/fixuid && \
    mkdir -p /etc/fixuid && \
    printf "user: $USER\ngroup: $GROUP\n" > /etc/fixuid/config.yml

RUN apt-get update -y && \
    mkdir /target && \
    chown maidsafe:maidsafe /target && \
    mkdir /usr/src/safe_client_libs && \
    chown maidsafe:maidsafe /usr/src/safe_client_libs && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/safe_client_libs
COPY . .

# Running the package script with --help caches the dependencies for the script.
USER maidsafe:maidsafe
ENV CARGO_TARGET_DIR=/target
RUN cargo install cargo-script && \
   ./scripts/build-real && \
   ./scripts/package.rs --help && \
   find /target/release/ -maxdepth 1 -type f -exec rm '{}' \;
ENTRYPOINT ["fixuid", "-q"]
