FROM golang:1.14

RUN apt-get update
RUN curl -f -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get update && apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

WORKDIR /rosalind
COPY . .
RUN go env -w GOPROXY=direct
RUN make release
