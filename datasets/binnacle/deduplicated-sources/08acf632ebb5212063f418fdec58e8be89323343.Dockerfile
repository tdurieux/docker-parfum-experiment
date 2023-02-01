FROM golang:alpine AS build-env

RUN apk add --no-cache git make

WORKDIR /src
ADD . /src
RUN make doh-client/doh-client

FROM alpine:latest

COPY --from=build-env /src/doh-client/doh-client /doh-client

ADD doh-client/doh-client.conf /doh-client.conf

RUN sed -i '$!N;s/"127.0.0.1:53",.*"127.0.0.1:5380",/":53",/;P;D' /doh-client.conf
RUN sed -i '$!N;s/"\[::1\]:53",.*"\[::1\]:5380",/":5380",/;P;D' /doh-client.conf

EXPOSE 53
EXPOSE 5380

ENTRYPOINT ["/doh-client"]
CMD ["-conf", "/doh-client.conf"]
