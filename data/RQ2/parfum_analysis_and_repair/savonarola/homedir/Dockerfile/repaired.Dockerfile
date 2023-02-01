FROM ubuntu

RUN apt-get update
RUN apt-get install --no-install-recommends -y zsh git curl htop vim rsync silversearcher-ag python3 && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y build-essential libssl-dev zlib1g-dev && rm -rf /var/lib/apt/lists/*;

RUN curl -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"
RUN cargo install bb bat exa eva hexyl mdcat

ADD . /homedir
RUN /homedir/install.pl

WORKDIR /root
CMD [ "/bin/bash", "/homedir/wait.sh" ]
