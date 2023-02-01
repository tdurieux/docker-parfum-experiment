# build stage
# build stage
ARG revision
FROM thundernetes-src:$revision as builder

RUN go build -o initcontainer ./cmd/initcontainer/

# final stage