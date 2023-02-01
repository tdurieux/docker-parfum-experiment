# frontend client with dev-config

FROM collabtexteditor/go-server-common

WORKDIR /go/src/app/backend

COPY /backend/*.go .

RUN go build -gcflags "all=-N -l" -o main .

# port 40000 for delve