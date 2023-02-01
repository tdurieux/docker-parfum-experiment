ARG GO_VERSION=${GO_VERSION:-1.12.1}

FROM golang:${GO_VERSION}-stretch

RUN apt-get update && \
 apt-get -y --no-install-recommends install rpm zip jq && rm -rf /var/lib/apt/lists/*;

#RUN useradd 1000
#USER 1000
#WORKDIR /home/1000