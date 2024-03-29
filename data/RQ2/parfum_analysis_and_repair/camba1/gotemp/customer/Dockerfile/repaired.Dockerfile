# Build DEv image with hot rebuild
FROM golang AS dev

ENV SRVDIR=customer

ENV SRVNAME=${SRVDIR}Server
WORKDIR /go/src/goTemp
RUN go get github.com/githubnemo/CompileDaemon
ENV GO111MODULE=on
COPY ./go.mod ./go.sum ./
RUN go mod download
COPY ./$SRVDIR ./$SRVDIR
COPY ./user/proto ./user/proto
COPY ./globalerrors ./globalerrors
COPY ./globalUtils ./globalUtils
COPY ./globalProtos ./globalProtos
COPY ./globalMonitoring ./globalMonitoring
RUN go build -o $SRVNAME ./$SRVDIR/server/
EXPOSE 50051
EXPOSE 2112
CMD ./$SRVNAME

# Compile the Alpine version of the application
FROM dev AS alpBuild

ENV SRVDIR=customer

ENV SRVNAME=${SRVDIR}ServerAlp
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o $SRVNAME ./$SRVDIR/server/

# Build the Alpine image