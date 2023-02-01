FROM golang:latest

LABEL maintainer="Austin Mac <amac@roblox.com>"

ENV CONNECTION_STRING="Server=mssql;Database=master;User Id=sa;Password=yourStrong(!)Password;"

RUN mkdir -p /go/src/nurd

WORKDIR /go/src/nurd

COPY . .

RUN apt-get update && apt-get install --no-install-recommends -y vim && rm -rf /var/lib/apt/lists/*;
RUN go mod download

RUN make install

EXPOSE 8080

CMD ["nurd"]