ARG VERSION=1.15
FROM golang:${VERSION}

# Install VCS tools to support "go get" commands and install gcc.
RUN apt-get update -qqy && apt-get install --no-install-recommends -qqy git mercurial subversion gcc && rm -rf /var/lib/apt/lists/*;

# We blank out the GOPATH because the base image sets it, and
# if the user of this build step does *not* set it, we want to
# explore other options for workspace derivation.
ENV GOPATH=

RUN mkdir /builder

COPY go_workspace.go prepare_workspace.inc /builder/

COPY go.bash /builder/bin/
ENV PATH=/builder/bin:$PATH

RUN go build -o /builder/go_workspace /builder/go_workspace.go

ENTRYPOINT ["go.bash"]
