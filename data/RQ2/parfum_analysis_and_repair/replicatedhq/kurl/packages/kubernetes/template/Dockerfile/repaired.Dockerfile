FROM ubuntu:20.04
RUN apt-get update
RUN apt-get -y --no-install-recommends install curl apt-transport-https gnupg && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add
RUN echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list
RUN apt-get update
