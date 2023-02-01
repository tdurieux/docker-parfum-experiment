FROM golang:1.18

RUN apt-get update && apt-get install --no-install-recommends -y libcairo2-dev && rm -rf /var/lib/apt/lists/*;

WORKDIR /go/src/github.com/bookingcom/carbonapi
COPY . .
COPY ./config/carbonapi.yaml /etc/carbonapi.yaml

RUN make build

EXPOSE 7081
EXPOSE 8081

ENTRYPOINT [ "/go/src/github.com/bookingcom/carbonapi/carbonapi",  "-config", "config/carbonapi.yaml" ]
