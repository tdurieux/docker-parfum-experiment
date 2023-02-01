FROM jenkins/jenkins:lts

USER root
RUN apt-get update && apt-get install --no-install-recommends -y python3 python3-pip && \
    pip3 install --no-cache-dir ansible && rm -rf /var/lib/apt/lists/*;

RUN wget https://golang.org/dl/go1.15.6.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go1.15.6.linux-amd64.tar.gz && rm go1.15.6.linux-amd64.tar.gz

ENV PATH=$PATH:/usr/local/go/bin
ENV ANSIBLE_HOST_KEY_CHECKING=False

USER jenkins