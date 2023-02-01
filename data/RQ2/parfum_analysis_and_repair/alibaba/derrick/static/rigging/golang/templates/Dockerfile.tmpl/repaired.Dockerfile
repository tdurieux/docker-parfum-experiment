# build stage
FROM golang:{{ .Version }} AS build-env
ADD . /src/{{ .ProjectFolder }}
ENV GOPATH /:/src/{{ .ProjectFolder }}/vendor
ENV CGO_ENABLED=0
WORKDIR /src/{{ .ProjectFolder }}
RUN go build -o app


# test stage
#FROM golang:{{ .Version }}
#WORKDIR /src/{{ .ProjectFolder }}
#RUN go test


# release stage