FROM ansible/ansible:ubuntu1604

RUN pip install --no-cache-dir testinfra ansible && mkdir -p /conjurinc/ansible-role-conjur/

RUN apt-get update && apt-get install --no-install-recommends -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common && rm -rf /var/lib/apt/lists/*;

RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
RUN add-apt-repository \
       "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
       $(lsb_release -cs) \
       stable"
RUN apt-get update && apt-get -y --no-install-recommends install docker-ce && rm -rf /var/lib/apt/lists/*;
RUN apt-get update && apt-get install --no-install-recommends -y gcc build-essential && rm -rf /var/lib/apt/lists/*;
RUN apt-add-repository -y ppa:brightbox/ruby-ng && apt-get update && apt-get install --no-install-recommends -y ruby2.4 ruby2.4-dev && rm -rf /var/lib/apt/lists/*;
RUN gem install conjur-cli

WORKDIR /conjurinc/ansible-role-conjur/
