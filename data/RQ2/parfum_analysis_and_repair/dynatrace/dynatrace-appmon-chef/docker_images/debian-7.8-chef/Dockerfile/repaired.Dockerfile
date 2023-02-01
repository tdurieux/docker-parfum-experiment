FROM debian:7.8
RUN apt-get update
RUN apt-get install --no-install-recommends -y sudo openssh-server curl lsb-release && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y net-tools tar && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sSL https://www.opscode.com/chef/install.sh | sudo bash -s -- -v 12.19.36
