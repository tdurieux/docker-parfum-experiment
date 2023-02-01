FROM alpine:latest
RUN apk update && apk add --no-cache ca-certificates
ENV HTTPPORT=8080
ADD paymentservice .
EXPOSE 8080
CMD ./paymentservice