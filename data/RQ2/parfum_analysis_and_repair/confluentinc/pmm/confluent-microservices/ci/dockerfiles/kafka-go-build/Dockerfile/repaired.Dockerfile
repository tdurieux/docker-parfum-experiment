FROM ubuntu

ENV GOROOT=/usr/local/go
ENV PATH=$GOPATH/bin:$GOROOT/bin:$PATH

RUN apt-get update
RUN apt-get install --no-install-recommends -y wget && rm -rf /var/lib/apt/lists/*;
RUN wget "https://dl.google.com/go/go1.12.7.linux-amd64.tar.gz"
RUN tar -xvf go1.12.7.linux-amd64.tar.gz && rm go1.12.7.linux-amd64.tar.gz
RUN mv go /usr/local
RUN apt-get install --no-install-recommends -y pkg-config && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
RUN wget -qO - https://packages.confluent.io/deb/5.3/archive.key | apt-key add -
RUN add-apt-repository "deb [arch=amd64] https://packages.confluent.io/deb/5.3 stable main"
RUN apt-get update
RUN apt-get install --no-install-recommends -y librdkafka-dev && rm -rf /var/lib/apt/lists/*;