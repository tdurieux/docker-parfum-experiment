FROM golang:1.18
# We need to have both nodejs and go to build the binaries.
# We could use multi-stage builds but that would require significantly changing our Makefile.
RUN apt-get update
RUN curl -f -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get update && apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

WORKDIR /copilot
COPY . .
RUN go env -w GOPROXY=direct
RUN make release
