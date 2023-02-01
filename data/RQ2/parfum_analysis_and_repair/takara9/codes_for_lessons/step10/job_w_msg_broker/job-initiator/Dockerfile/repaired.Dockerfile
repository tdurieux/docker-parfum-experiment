FROM ubuntu:16.04
RUN apt-get update && apt-get install --no-install-recommends -y iputils-ping dnsutils curl apt-transport-https && rm -rf /var/lib/apt/lists/*;

# install kubectl
RUN curl -f -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
RUN touch /etc/apt/sources.list.d/kubernetes.list
RUN echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list
RUN apt-get update && apt-get install --no-install-recommends -y kubectl && rm -rf /var/lib/apt/lists/*;

# pyhon
RUN apt-get install --no-install-recommends -y python python-pip && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir pika kubernetes

