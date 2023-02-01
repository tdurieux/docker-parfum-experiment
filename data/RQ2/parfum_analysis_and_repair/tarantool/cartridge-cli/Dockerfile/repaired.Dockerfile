FROM centos:7

ARG GOVERSION=1.17

RUN yum -y update
RUN yum install -y git gcc make cmake unzip python3-pip python3-devel && rm -rf /var/cache/yum

RUN yum install -y yum-utils device-mapper-persistent-data lvm2 && rm -rf /var/cache/yum
RUN yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
RUN yum install -y docker-ce-18.09.1 && rm -rf /var/cache/yum

RUN git config --global user.email "test@tarantool.io" \
	&& git config --global user.name "Test Tarantool"

VOLUME /var/lib/docker

ENV PORT=2375

ADD wrapdocker /usr/local/bin/wrapdocker
RUN chmod +x /usr/local/bin/wrapdocker

RUN curl -f -O -L https://dl.google.com/go/go${GOVERSION}.linux-amd64.tar.gz \
    && tar -C /usr/local -xzf /go${GOVERSION}.linux-amd64.tar.gz && rm /go${GOVERSION}.linux-amd64.tar.gz

ENV PATH=${PATH}:/usr/local/go/bin
ENV GOPATH=/home/go
ENV PATH=$PATH:${GOPATH}/bin

RUN go get -u -d github.com/magefile/mage \
    && cd $GOPATH/src/github.com/magefile/mage \
    && go run bootstrap.go

COPY test/requirements.txt /tmp/test/
RUN pip3 install --no-cache-dir --user -r /tmp/test/requirements.txt

EXPOSE 2375

ENTRYPOINT [ "/usr/local/bin/wrapdocker" ]

CMD ["/bin/bash" , "-l"]
