FROM golang:1.17.8@sha256:c7c94588b6445f5254fbc34df941afa10de04706deb330e62831740c9f0f2030 AS builder

WORKDIR /root/

RUN go install github.com/google/trillian/cmd/createtree@v1.3.10
ADD ./config/logid.sh /root/
ADD ./config/ctfe /root/ctfe
RUN chmod +x /root/logid.sh

CMD /root/logid.sh