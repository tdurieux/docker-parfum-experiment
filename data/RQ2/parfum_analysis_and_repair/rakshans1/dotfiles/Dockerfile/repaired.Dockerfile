FROM ubuntu:16.04

RUN apt-get update && apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;

RUN git clone https://github.com/rakshans1/dotfiles

RUN cd dotfiles && ./setup-new-machine.sh