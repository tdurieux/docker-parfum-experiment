FROM ubuntu:20.04

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y curl mingw-w64 nsis && rm -rf /var/lib/apt/lists/*;

RUN cd ~ && curl -f -LO https://golang.org/dl/go1.16.3.linux-amd64.tar.gz
RUN tar -C /usr/local -xf ~/go1.16.3.linux-amd64.tar.gz && rm ~/go1.16.3.linux-amd64.tar.gz
RUN echo 'export PATH="$PATH:/usr/local/go/bin"' >> ~/.bashrc

CMD /bin/bash
