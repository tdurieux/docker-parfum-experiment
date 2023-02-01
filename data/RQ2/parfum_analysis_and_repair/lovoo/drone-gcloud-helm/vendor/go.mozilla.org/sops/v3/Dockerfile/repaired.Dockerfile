FROM golang:1.12

COPY . /go/src/go.mozilla.org/sops
WORKDIR /go/src/go.mozilla.org/sops

RUN CGO_ENABLED=1 make install
RUN apt-get update && apt-get install --no-install-recommends -y vim python-pip emacs && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir awscli
ENV EDITOR vim
