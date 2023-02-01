FROM ubuntu:20.04

RUN apt-get update
RUN apt-get install --no-install-recommends -y curl sudo git findutils gnupg2 dpkg-dev && rm -rf /var/lib/apt/lists/*;
RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
RUN echo "deb https://apt.releases.hashicorp.com focal main" | sudo tee -a /etc/apt/sources.list.d/packer.list
RUN apt-get update
RUN apt-get install --no-install-recommends -y packer && rm -rf /var/lib/apt/lists/*;
