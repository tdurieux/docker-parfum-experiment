FROM ubuntu:bionic
MAINTAINER Gianluca Natali gnatali@confluent.io

ENV PATH /opt:$PATH

RUN apt-get -y update
RUN apt-get -y upgrade
RUN apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends python3 -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends python3-yaml -y && rm -rf /var/lib/apt/lists/*;
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3 1
RUN apt-get install --no-install-recommends wget unzip -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends curl -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends jq -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends git -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends nano -y && rm -rf /var/lib/apt/lists/*;

RUN wget --quiet https://releases.hashicorp.com/terraform/1.0.0/terraform_1.0.0_linux_amd64.zip \
  && unzip terraform_1.0.0_linux_amd64.zip \
  && mv terraform /usr/bin \
  && rm terraform_1.0.0_linux_amd64.zip

RUN curl -f -L --http1.1 https://cnfl.io/ccloud-cli | sh -s -- -b /opt

RUN apt-get install --no-install-recommends nodejs npm -y && rm -rf /var/lib/apt/lists/*;
RUN npm install -g mongodb-realm-cli && npm cache clean --force;
