FROM golang:alpine
RUN apk add --no-cache git
RUN go get github.com/BytecodeAgency/import-boundary-checker
RUN go install github.com/BytecodeAgency/import-boundary-checker
WORKDIR /opt/importchecker
COPY . .
CMD ["import-boundary-checker"]
