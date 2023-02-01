FROM ubuntu:focal-20220531

ADD setup.sh /setup.sh
RUN ./setup.sh

ENV JAVA_HOME /opt/openjdk
ENV PATH $JAVA_HOME/bin:$PATH

RUN apt-get update && \
    apt-get install --no-install-recommends -y wget && \
    wget https://github.com/k14s/ytt/releases/download/v0.27.2/ytt-linux-amd64 && \
	mv ytt-linux-amd64 /usr/local/bin/ytt && \
	chmod +x /usr/local/bin/ytt && rm -rf /var/lib/apt/lists/*;

RUN apt-get update && \
	apt-get install --no-install-recommends -y apt-transport-https gnupg2 && \
	curl -f -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
	echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list && \
	apt-get update && \
	apt-get install --no-install-recommends -y kubectl && rm -rf /var/lib/apt/lists/*;

