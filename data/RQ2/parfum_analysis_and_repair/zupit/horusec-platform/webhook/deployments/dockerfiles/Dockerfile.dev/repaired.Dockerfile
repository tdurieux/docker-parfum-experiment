FROM golang

ADD . /webhook

WORKDIR /webhook

RUN go get -d ./...
RUN go get github.com/cosmtrek/air

CMD ["air", "-c", "deployments/air/config.toml"]