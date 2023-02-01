FROM ubuntu
RUN apt-get update -y && apt-get dist-upgrade -y && apt-get install curl gcc xfsprogs git -y
RUN curl -O https://storage.googleapis.com/golang/go1.12.5.linux-amd64.tar.gz
RUN tar -C /usr/local/ -xvf go1.12.5.linux-amd64.tar.gz
RUN mkdir -p /LINBIT/linstor-csi/
ADD . /LINBIT/linstor-csi/
ADD ./vendor/github.com/LINBIT/golinstor /LINBIT/golinstor/
WORKDIR /LINBIT/linstor-csi/pkg/driver
ENV PATH=$PATH:/usr/local/go/bin
RUN go version
RUN go get ./...
MAINTAINER Hayley Swimelar <hayley@linbit.com>
ENTRYPOINT ["go", "test", "-args"]
