FROM golang:alpine AS build_base
RUN apk add --no-cache git
WORKDIR /build
COPY go.mod .
COPY go.sum .
RUN go mod download

FROM build_base AS build
COPY . .
RUN CGO_ENABLED=0 go install .

FROM alpine AS pcwauth
COPY --from=build /go/bin/pcwpkg /bin/pcwpkg
CMD pcwpkg \
	-dsn "${MYSQL_USER}:${MYSQL_PASSWORD}@(db)/${MYSQL_DATABASE}" \
	-listen ':80' \
	-debug
