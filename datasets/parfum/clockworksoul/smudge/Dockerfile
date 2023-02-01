# This is a multi-stage Dockerfile. The first part executes a build in a Golang
# container, and the second retrieves the binary from the build container and
# inserts it into a "scratch" image.

# Part 1: Compile the binary in a containerized Golang environment
#
FROM golang:1.14 as test

COPY . /go/src/github.com/clockworksoul/smudge

WORKDIR /go/src/github.com/clockworksoul/smudge

RUN go test -v ./...


# Part 2: Compile the binary in a containerized Go environment
#
FROM golang:1.14 as build

COPY . /go/src/github.com/clockworksoul/smudge

RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o /smudge github.com/clockworksoul/smudge/smudge


# Part 3: Build the Smudge image proper
#
FROM scratch as image

COPY --from=build /smudge .

EXPOSE 9999

CMD ["/smudge"]
