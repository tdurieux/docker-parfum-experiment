FROM ubuntu:20.04

RUN apt-get update && \
      apt-get -y --no-install-recommends install sudo && rm -rf /var/lib/apt/lists/*;

# fixes prompts during apt installations
RUN echo 'debconf debconf/frontend select Noninteractive' | sudo debconf-set-selections
RUN sudo apt-get install -y -q
RUN DEBIAN_FRONTEND=noninteractive sudo apt-get -y --no-install-recommends install keyboard-configuration && rm -rf /var/lib/apt/lists/*;

RUN sudo apt-get -y update && sudo apt-get -y --no-install-recommends install software-properties-common git && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /opt/klaxalk/git && cd /opt/klaxalk/git && git clone https://github.com/klaxalk/linux-setup --depth 1

RUN cd /opt/klaxalk/git/linux-setup && ./install.sh --unattended --docker && rm -rf /var/lib/apt/lists/*

CMD ["bash"]
