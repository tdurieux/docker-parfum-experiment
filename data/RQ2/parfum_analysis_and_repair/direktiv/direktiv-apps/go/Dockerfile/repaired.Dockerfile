# FROM golang as build

# WORKDIR /app
# COPY ./main.go ./
# COPY ./go.mod ./
# COPY ./go.sum ./
# RUN go get -u -v

FROM alpine:latest as certs
# COPY --from=build /buildgo /