# Build DEv image with hot rebuild
FROM golang AS dev

ENV CLIDIR=user

ENV CLINAME=${CLIDIR}Client
WORKDIR /go/src/goTemp
RUN go get github.com/githubnemo/CompileDaemon
ENV GO111MODULE=on
COPY ./go.mod ./go.sum ./
RUN go mod download
COPY ./$CLIDIR ./$CLIDIR
#COPY ./go.mod ./go.sum ./
#RUN go get -d  -v ./...
RUN go build -o $CLINAME ./$CLIDIR/client/
EXPOSE 50051
CMD ./$CLINAME

# Compile the Alpine version of the application
FROM dev AS AlpBuild

ENV CLIDIR=user

ENV CLINAME=${CLIDIR}ClientAlp
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o $CLINAME ./$CLIDIR/client/

# Build the Alpine image