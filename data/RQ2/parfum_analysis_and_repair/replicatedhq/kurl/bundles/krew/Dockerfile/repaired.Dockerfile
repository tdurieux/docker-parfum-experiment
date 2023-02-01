FROM ubuntu:18.04
RUN apt-get update && apt-get -y --no-install-recommends install curl apt-transport-https gnupg git && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /krew
WORKDIR /krew

RUN curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/download/v0.3.2/krew.{tar.gz,yaml}" && \
	tar zxvf krew.tar.gz && \
	./krew-linux_amd64 install --manifest=krew.yaml --archive=krew.tar.gz && \
	./krew-linux_amd64 update && \
	rm krew-* && rm krew.tar.gz

RUN cp /root/.krew/index/plugins/outdated.yaml /krew
RUN cp /root/.krew/index/plugins/preflight.yaml /krew
RUN cp /root/.krew/index/plugins/support-bundle.yaml /krew

RUN tar cf index.tar -C /root/.krew index

RUN curl -f -L $(cat /root/.krew/index/plugins/outdated.yaml | grep linux_amd64 | awk '{ print $2 }') > outdated.tar.gz
RUN curl -f -L $(cat /root/.krew/index/plugins/preflight.yaml | grep linux_amd64 | awk '{ print $2 }') > preflight.tar.gz
RUN curl -f -L $(cat /root/.krew/index/plugins/support-bundle.yaml | grep linux_amd64 | awk '{ print $2 }') > support-bundle.tar.gz
