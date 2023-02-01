FROM brimstone/ubuntu:14.04

CMD []

ENTRYPOINT ["/usr/bin/consul", "agent", "-server", "-data-dir=/consul", "-client=0.0.0.0", "-ui-dir=/webui"]

EXPOSE 8500 8600 8400 8301 8302

RUN apt-get update \
    && apt-get install --no-install-recommends -y unzip wget \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists && rm -rf /var/lib/apt/lists/*;

RUN cd /tmp \
    && wget https://dl.bintray.com/mitchellh/consul/0.3.1_web_ui.zip \
       -O web_ui.zip \
    && unzip web_ui.zip \
    && mv dist /webui \
    && rm web_ui.zip

RUN apt-get update \
	&& dpkg -l | awk '/^ii/ {print $2}' > /tmp/dpkg.clean \
    && apt-get install -y --no-install-recommends unzip wget \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists \

    && cd /tmp \
    && wget https://dl.bintray.com/mitchellh/consul/0.3.1_web_ui.zip \
       -O web_ui.zip \
    && unzip web_ui.zip \
    && mv dist /webui \
    && rm web_ui.zip \

	&& dpkg -l | awk && rm -rf /var/lib/apt/lists/*;

ENV GOPATH /go

RUN apt-get update \
	&& dpkg -l | awk '/^ii/ {print $2}' > /tmp/dpkg.clean \
    && apt-get install -y --no-install-recommends git golang ca-certificates build-essential \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists \

	&& go get -v github.com/hashicorp/consul \
	&& mv $GOPATH/bin/consul /usr/bin/consul \

	&& dpkg -l | awk \
	&& apt-get remove && rm -rf /var/lib/apt/lists/*;
