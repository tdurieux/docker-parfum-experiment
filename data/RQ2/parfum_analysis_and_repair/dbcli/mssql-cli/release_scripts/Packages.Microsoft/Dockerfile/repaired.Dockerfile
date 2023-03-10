FROM amd64/ubuntu:18.04 AS builder

RUN apt-get update
RUN apt-get -y --no-install-recommends install wget curl nano sudo gnupg gnupg2 gnupg1 jq && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install apt-transport-https && rm -rf /var/lib/apt/lists/*;

# Requirements for installing the Repo CLI for Packages.Microsoft
ADD ./release_scripts/Packages.Microsoft/config.json /root/.repoclient/config.json
ADD ./release_scripts/Packages.Microsoft/private.pem /root/private.pem

# Install Repo CLI requirements
RUN curl -f https://tux-devrepo.corp.microsoft.com/keys/tux-devrepo.asc > tux-devrepo.asc
RUN apt-key add tux-devrepo.asc
RUN echo "deb [arch=amd64] http://tux-devrepo.corp.microsoft.com/repos/tux-dev/ xenial main" | tee /etc/apt/sources.list.d/tuxdev.list
RUN apt-get update

# Add mssql-cli repo
WORKDIR /root
RUN mkdir Repos
RUN mkdir Repos/mssql-cli
ADD . Repos/mssql-cli

# add privileges to publish script
WORKDIR /root/Repos/mssql-cli
RUN chmod +x release_scripts/Packages.Microsoft/publish.sh
