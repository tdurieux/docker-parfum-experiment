FROM ubuntu:14.04
MAINTAINER speed "blaz@roave.com"

RUN apt-get -y update && apt-get -y --no-install-recommends install software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN sudo add-apt-repository ppa:brightbox/ruby-ng
RUN apt-get -y update && apt-get -y --no-install-recommends install git ruby2.1-dev build-essential wget curl mercurial && apt-get clean && rm -rf /var/lib/apt/lists/*;
RUN wget https://storage.googleapis.com/golang/go1.2.2.linux-amd64.tar.gz -O - -q | tar -C /usr/local -xz
ENV PATH $PATH:/usr/local/go/bin
RUN mkdir -p $HOME/go
ENV GOPATH $HOME/go
ENV GOROOT /usr/local/go
ENV PATH $PATH:$GOROOT/bin:$GOPATH/bin
RUN go get github.com/tools/godep

RUN git clone https://github.com/flynn/gitreceived.git /opt/gitreceived
RUN cd /opt/gitreceived && godep go build

RUN gem install excon docker-api json

ADD receive /bin/dawn-receive
ADD authorize /bin/dawn-authorize
EXPOSE 2201

cmd ["/opt/gitreceived/gitreceived", "-p", "2201", "/bin/dawn-authorize", "/bin/dawn-receive"]
