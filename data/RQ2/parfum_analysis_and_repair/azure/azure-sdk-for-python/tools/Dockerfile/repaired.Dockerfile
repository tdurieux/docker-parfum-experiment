# public OSS users should simply leave this argument blank or ignore its presence entirely
ARG REGISTRY=""
FROM ${REGISTRY}ubuntu:20.04
LABEL MAINTAINER=zikalino \
      MAINTAINER=scbedd

RUN apt-get update
RUN apt-get install --no-install-recommends -y git curl gnupg vim python3 python3-pip git software-properties-common apt-transport-https wget python3-venv nodejs npm libunwind-dev && rm -rf /var/lib/apt/lists/*;

# install dotnet
RUN add-apt-repository "deb http://security.ubuntu.com/ubuntu xenial-security main"
RUN apt-get update
RUN apt-get install --no-install-recommends -y libicu55 && rm -rf /var/lib/apt/lists/*;

RUN wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
RUN dpkg -i packages-microsoft-prod.deb
RUN apt-get update
RUN apt-get install --no-install-recommends -y dotnet-sdk-2.2 && rm -rf /var/lib/apt/lists/*;

# install autorest
RUN npm install -g autorest && npm cache clean --force;
RUN npm install -g n && npm cache clean --force;
RUN n 10.15.0

RUN pip3 install --no-cache-dir wheel

# clone repos
RUN git clone https://github.com/Azure/azure-rest-api-specs.git
RUN git clone https://github.com/Azure/azure-sdk-for-python.git

# setup virtual env
RUN cd /azure-sdk-for-python; python3 -m venv env3.7
ENV VIRTUAL_ENV /azure-sdk-for-python;/env3.7
ENV PATH /azure-sdk-for-python/env3.7/bin:$PATH

# run setup
RUN cd /azure-sdk-for-python; python ./scripts/dev_setup.py
