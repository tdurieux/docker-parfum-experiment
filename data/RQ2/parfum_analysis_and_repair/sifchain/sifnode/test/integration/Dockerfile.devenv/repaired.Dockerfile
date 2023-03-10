FROM ubuntu:20.04
LABEL org.opencontainers.image.source https://github.com/sifchain/sifnode
RUN apt-get update && apt-get install --no-install-recommends -y sudo && rm -rf /var/lib/apt/lists/*;
RUN yes | sudo unminimize
RUN useradd -m vagrant
RUN echo "vagrant ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/vagrant
COPY setup-linux-environment-root.sh setup-linux-environment.sh setup-linux-environment-user.sh /setup/
USER vagrant
RUN cd /setup && ./setup-linux-environment.sh
