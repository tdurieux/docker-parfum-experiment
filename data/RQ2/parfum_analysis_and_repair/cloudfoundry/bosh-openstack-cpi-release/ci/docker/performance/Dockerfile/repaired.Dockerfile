FROM bosh/cli2:latest

RUN locale-gen en_US.UTF-8
RUN dpkg-reconfigure locales
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

RUN apt-get update && apt-get install --no-install-recommends -y wget git && rm -rf /var/lib/apt/lists/*;

RUN wget https://redirector.gvt1.com/edgedl/go/go1.9.2.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go1.9.2.linux-amd64.tar.gz && rm go1.9.2.linux-amd64.tar.gz

ENV PATH $PATH:/usr/local/go/bin:/root/go/bin