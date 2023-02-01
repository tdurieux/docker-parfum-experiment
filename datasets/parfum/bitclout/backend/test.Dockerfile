FROM alpine:latest AS backend

RUN apk update
RUN apk upgrade
RUN apk add --update go gcc g++ vips-dev

WORKDIR /deso/src

COPY backend/go.mod backend/
COPY backend/go.sum backend/
COPY core/go.mod core/
COPY core/go.sum core/

WORKDIR /deso/src/backend

RUN go mod download

# include backend src
COPY backend/apis      apis
COPY backend/cmd       cmd
COPY backend/miner     miner
COPY backend/routes    routes
COPY backend/countries countries
COPY backend/main.go   .

# include core src
COPY core/desohash ../core/desohash
COPY core/cmd       ../core/cmd
COPY core/lib       ../core/lib
COPY core/migrate   ../core/migrate

# build backend
RUN GOOS=linux go build -mod=mod -a -installsuffix cgo -o bin/backend main.go

ENTRYPOINT ["go", "test", "-v", "github.com/deso-protocol/backend/routes"]
