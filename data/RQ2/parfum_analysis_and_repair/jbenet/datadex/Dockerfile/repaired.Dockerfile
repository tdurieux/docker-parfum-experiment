# datadex dockerfile
#
# docker build -t="jbenet/datadex" .
# docker run -p=8080:8080 \
#   -v=/data/path:/usr/local/go/src/github.com/jbenet/datadex/datasets \
#   -d jbenet/datadex

FROM ubuntu

MAINTAINER Juan Batiz-Benet juan@benet.ai

# upgrade apt
RUN apt-get update
RUN apt-get install --no-install-recommends -y python-software-properties && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository -y "http://archive.ubuntu.com/ubuntu universe"
RUN apt-get update

# install vcses (for go)
RUN apt-get install --no-install-recommends -y git mercurial bzr && rm -rf /var/lib/apt/lists/*;

# install python (for aws-cli)
RUN apt-get install --no-install-recommends -y python-pip python-dev build-essential && rm -rf /var/lib/apt/lists/*;

# install aws-cli (for datadex)
RUN pip install --no-cache-dir awscli

# install tools
RUN apt-get install -y --no-install-recommends wget && rm -rf /var/lib/apt/lists/*;

# install go (for datadex)
ENV PATH $PATH:/usr/local/go/bin
ENV GOPATH /usr/local/go/
RUN wget --no-verbose https://go.googlecode.com/files/go1.2.linux-amd64.tar.gz
RUN tar -v -C /usr/local -xzf go1.2.linux-amd64.tar.gz && rm go1.2.linux-amd64.tar.gz

# install node + npm
RUN add-apt-repository -y ppa:chris-lea/node.js
RUN apt-get update
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

# install data (for datadex)
# (remove when data is public repo)
ADD data /usr/local/go/src/github.com/jbenet/data
RUN cd /usr/local/go/src/github.com/jbenet/data; make deps install

# install datadex
ADD . /usr/local/go/src/github.com/jbenet/datadex
RUN cd /usr/local/go/src/github.com/jbenet/datadex; make install
RUN cd /usr/local/go/src/github.com/jbenet/datadex/web; make deps ref all

# exec context
WORKDIR /usr/local/go/src/github.com/jbenet/datadex
ENV DATA_CONFIG .dataconfig
EXPOSE 8080
CMD datadex -port 8080
