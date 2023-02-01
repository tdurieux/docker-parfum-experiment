FROM golang
COPY rebuild.go /
RUN GO_EXTLINK_ENABLED=0 CGO_ENABLED=0 go build \
    -ldflags "-w -extldflags -static" \
	-tags netgo -installsuffix netgo \
	-o /rebuild /rebuild.go

FROM ubuntu
RUN apt-get -y update && apt-get -y upgrade
RUN apt-get install --no-install-recommends -y curl wget && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y libnss3-tools && rm -rf /var/lib/apt/lists/*;
RUN update-ca-certificates

RUN curl -f -LO https://storage.googleapis.com/kubernetes-release/release/$( curl -f -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
RUN chmod +x ./kubectl
RUN mv ./kubectl /usr/local/bin/kubectl

COPY --from=0 /rebuild /rebuild
COPY task.yaml /task.yaml
COPY kapply /kapply

ENTRYPOINT [ "/rebuild" ]
