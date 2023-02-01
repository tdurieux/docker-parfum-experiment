# Build DEv image with hot rebuild
FROM golang AS dev

ENV CLIDIR=product

ENV CLINAME=${CLIDIR}Client
WORKDIR /go/src/goTemp
RUN go get github.com/githubnemo/CompileDaemon
ENV GO111MODULE=on
COPY ./go.mod ./go.sum ./
RUN go mod download
COPY ./$CLIDIR ./$CLIDIR
COPY ./user/proto ./user/proto
COPY ./globalProtos ./globalProtos
RUN go build -o $CLINAME ./$CLIDIR/client/
EXPOSE 50051
CMD ./$CLINAME

# Compile the Alpine version of the application
FROM dev AS AlpBuild

ENV CLIDIR=product

ENV CLINAME=${CLIDIR}ClientAlp
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o $CLINAME ./$CLIDIR/client/

# Build the Alpine image