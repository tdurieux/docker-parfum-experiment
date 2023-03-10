FROM golang:1.14 as build

# Have to install chrome for this so had to use initial image not distroless
RUN apt-get update
RUN echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list
RUN wget https://dl-ssl.google.com/linux/linux_signing_key.pub
RUN apt-key add linux_signing_key.pub
RUN apt-get update
RUN apt-get install --no-install-recommends google-chrome-stable -y && rm -rf /var/lib/apt/lists/*;

WORKDIR $GOPATH

COPY . .

WORKDIR $GOPATH/src/github.com/diadata-org/diadata/internal/pkg/blockchain-scrapers/blockchains/tether/scrapers/usdt

RUN go get ./...

RUN go install

CMD ["usdt"]
