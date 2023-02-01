FROM golang:1.9

# Install basic applications
RUN apt-get update && apt-get install --no-install-recommends -y --fix-missing htop less && rm -rf /var/lib/apt/lists/*;

WORKDIR /go/src
COPY ./src .
COPY ./start_requestor.sh .

WORKDIR /go/src/requestor
RUN go-wrapper download requestor   # "go get -d -v ./..."
RUN go-wrapper install requestor   # "go install -v ./..."

WORKDIR /go/src

CMD ./start_requestor.sh
