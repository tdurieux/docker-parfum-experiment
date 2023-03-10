FROM golang:1.17.3-buster AS build
WORKDIR /src/

COPY go.mod go.sum ./
RUN go mod download
COPY . ./

RUN CGO_ENABLED=0 go build ./cmd/sale

FROM scratch
COPY --from=build /src/sale /bin/sale
EXPOSE 5005
ENTRYPOINT ["/bin/sale"]