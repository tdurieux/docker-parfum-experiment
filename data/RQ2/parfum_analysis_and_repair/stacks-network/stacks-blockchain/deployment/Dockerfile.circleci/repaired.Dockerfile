FROM circleci/rust

WORKDIR /kcov/

RUN sudo apt-get update
RUN sudo apt-get install -y --no-install-recommends cmake binutils-dev libcurl4-openssl-dev zlib1g-dev libdw-dev libiberty-dev git && rm -rf /var/lib/apt/lists/*;

ENV KCOV_VERSION 34
RUN sudo git clone --single-branch --branch v$KCOV_VERSION https://github.com/SimonKagstrom/kcov.git
RUN cd kcov && sudo cmake . && sudo make -j$(nproc) && sudo make install

RUN cargo install cargo-kcov