FROM ubuntu

RUN useradd -ms /bin/bash -G sudo opauser && \
    passwd -d opauser && \
    apt-get update && \
    apt-get install --no-install-recommends -y opam curl sudo openjdk-8-jre m4 zlib1g-dev && \
    curl -f -sL https://deb.nodesource.com/setup_8.x | sudo -E bash - && \
    sudo apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

USER opauser
WORKDIR /home/opauser

RUN opam init --auto-setup && \
    opam switch 4.02.1 && \
    opam install -y ocamlbuild ulex camlzip ocamlgraph camlp4 && \
    eval `opam config env` && \
    git clone https://github.com/MLstate/opalang --depth 1 && \
    cd opalang/ && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && \
    make && \
    sudo make install

RUN sudo npm install -g opabsl.opp intl-messageformat intl && npm cache clean --force;

# ENTRYPOINT opa
