FROM golang:1.15.4 AS build
COPY . /tester
WORKDIR /tester
RUN make build
RUN go test -c -o ./dist/db.test ./db
RUN go test -c -o ./dist/http.test ./http

FROM golang:1.15.4
COPY --from=build /tester/dist/tester-linux-amd64 /bin/tester
RUN mkdir -p /etc/tester
COPY --from=build /tester/config.json /etc/tester/config.json
COPY --from=build /tester/dist/db.test /bin/db.test
COPY --from=build /tester/dist/http.test /bin/http.test