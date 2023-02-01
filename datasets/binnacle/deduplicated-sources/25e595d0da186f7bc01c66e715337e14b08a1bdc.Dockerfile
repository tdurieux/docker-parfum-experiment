FROM likechain/golang as builder

# Copy files to WORKDIR
COPY . ./abci

# Build executables
RUN go build -a -o /bin/likechain/abci abci/cmd/abci/main.go
RUN go build -a -o /bin/likechain/api abci/cmd/api/main.go

FROM alpine:latest

WORKDIR /bin/likechain/

COPY --from=builder /bin/likechain/abci .
COPY --from=builder /bin/likechain/api .

CMD ["./abci"]
