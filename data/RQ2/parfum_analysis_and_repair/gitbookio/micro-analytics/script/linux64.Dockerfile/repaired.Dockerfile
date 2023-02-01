FROM golang:1.5

RUN apt-get -y update && apt-get -y --no-install-recommends install build-essential cmake && rm -rf /var/lib/apt/lists/*;

# Add micro-analytics source
ADD ./ $GOPATH/src/github.com/GitbookIO/micro-analytics

# Build
RUN cd $GOPATH/src/github.com/GitbookIO/micro-analytics && go get && go build --ldflags='-s'

# Try to run (to make sure executable works)
RUN $GOPATH/src/github.com/GitbookIO/micro-analytics/micro-analytics --help

# Copy out executable
RUN cp $GOPATH/src/github.com/GitbookIO/micro-analytics/micro-analytics /micro-analytics_linux_amd64
