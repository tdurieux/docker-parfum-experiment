FROM golang:1.11
RUN go get -u github.com/golang/dep/cmd/dep
RUN apt update
RUN apt install --no-install-recommends -y genisoimage && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y libseccomp-dev && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y sudo && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y jq && rm -rf /var/lib/apt/lists/*;
