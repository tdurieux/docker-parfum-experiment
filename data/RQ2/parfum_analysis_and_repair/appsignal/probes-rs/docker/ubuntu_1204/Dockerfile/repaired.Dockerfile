FROM ubuntu:12.04
RUN apt-get update && apt-get install --no-install-recommends -y apt-utils curl file sudo build-essential && rm -rf /var/lib/apt/lists/*;
RUN apt-get upgrade -y


RUN curl -f https://sh.rustup.rs > sh.rustup.rs
RUN sh sh.rustup.rs -y \
    && . $HOME/.cargo/env \
    && echo 'source $HOME/.cargo/env' >> $HOME/.bashrc

WORKDIR /probes
