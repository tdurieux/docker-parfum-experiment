FROM golang

ADD . /api

WORKDIR /api

RUN go get -d ./...
RUN go get github.com/cosmtrek/air

CMD ["air", "-c", "deployments/air/config.toml"]