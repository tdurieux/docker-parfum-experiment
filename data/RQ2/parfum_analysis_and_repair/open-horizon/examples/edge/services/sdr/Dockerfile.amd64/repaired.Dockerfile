FROM alpine:latest as rtl_build
RUN apk --no-cache add git cmake libusb-dev make gcc g++ alpine-sdk
WORKDIR /tmp
RUN git clone https://github.com/clementkng/librtlsdr
WORKDIR /tmp/librtlsdr

RUN mkdir build && cd build && cmake ../ && make && make install
RUN ls /usr/local/bin/rtl_*

FROM golang:1.15-alpine as go_build
RUN apk --no-cache add git
RUN go get github.com/hajimehoshi/go-mp3
COPY main.go /
COPY rtlsdrclientlib/clientlib.go /go/src/github.com/open-horizon/examples/edge/services/sdr/rtlsdrclientlib/clientlib.go
COPY bbcfake/bbcfake.go /go/src/github.com/open-horizon/examples/edge/services/sdr/bbcfake/bbcfake.go
ARG version=0.0.2
ENV MIC_VERSION $version
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo --ldflags "-X main.version=${MIC_VERSION}" -o /bin/rtlsdrd /main.go

FROM alpine:latest
RUN apk --no-cache add alsa-utils libusb ca-certificates curl jq bash
COPY --from=go_build /bin/rtlsdrd /bin/rtlsdrd
COPY --from=rtl_build /usr/local/bin/rtl_rpcd /bin/rtl_rpcd
COPY --from=rtl_build /usr/local/bin/rtl_fm /bin/rtl_fm
COPY --from=rtl_build /usr/local/bin/rtl_power /bin/rtl_power
COPY --from=rtl_build /usr/local/lib/librtlsdr.so.0 /usr/local/lib/librtlsdr.so.0
WORKDIR /
RUN addgroup -S hzngroup && adduser -S hznuser -G hzngroup
USER hznuser
EXPOSE 8080
CMD ["/bin/rtlsdrd"]