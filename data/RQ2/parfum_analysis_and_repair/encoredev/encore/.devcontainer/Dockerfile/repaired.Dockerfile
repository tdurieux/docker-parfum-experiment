FROM golang:1.16

RUN apt-get update && apt-get install --no-install-recommends -y sudo && rm -rf /var/lib/apt/lists/*;
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash - && \
	apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

ADD scripts /scripts
RUN bash /scripts/install.sh
RUN bash /scripts/godeps.sh

ENV ENCORE_GOROOT=/encore-release/encore-go
