From ubuntu:16.04
RUN apt-get update
RUN apt-get install --no-install-recommends -y wget apt-transport-https ca-certificates awscli && rm -rf /var/lib/apt/lists/*;
RUN echo "deb https://apt.repos.neuron.amazonaws.com xenial main" > /etc/apt/sources.list.d/neuron.list
RUN wget -qO - https://apt.repos.neuron.amazonaws.com/GPG-PUB-KEY-AMAZON-AWS-NEURON.PUB | apt-key add -

RUN apt-get update
RUN apt-get install --no-install-recommends -y tensorflow-model-server-neuron && rm -rf /var/lib/apt/lists/*;