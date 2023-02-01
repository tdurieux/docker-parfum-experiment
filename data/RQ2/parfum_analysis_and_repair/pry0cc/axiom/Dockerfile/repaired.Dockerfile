FROM ubuntu:latest

ENV PATH=$PATH:/root/.axiom/interact

RUN apt-get update \
    && apt-get install --no-install-recommends -yq apt-utils build-essential curl gcc \
    readline-common neovim git zsh zsh-syntax-highlighting zsh-autosuggestions jq build-essential python3-pip unzip git p7zip libpcap-dev rubygems ruby-dev grc && rm -rf /var/lib/apt/lists/*;

WORKDIR /root/.axiom
RUN git clone https://github.com/pry0cc/axiom/root/.axiom/
ENTRYPOINT ["/bin/zsh"]
