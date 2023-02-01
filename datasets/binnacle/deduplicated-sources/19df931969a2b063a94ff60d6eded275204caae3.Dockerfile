FROM golang:1.7.5  
WORKDIR /go/src/github.com/alexellis/faas/gateway  
  
COPY vendor vendor  
  
COPY handlers handlers  
COPY metrics metrics  
COPY requests requests  
COPY tests tests  
COPY server.go .  
COPY types types  
COPY plugin plugin  
  
RUN go test -v ./tests && \  
CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o app .  

