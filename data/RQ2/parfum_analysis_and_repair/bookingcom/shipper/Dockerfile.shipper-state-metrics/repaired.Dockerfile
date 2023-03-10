FROM alpine:3.12.3
LABEL authors="Parham Doustdar <parham.doustdar@booking.com>, Alexey Surikov <alexey.surikov@booking.com>, Igor Sutton <igor.sutton@booking.com>, Ben Tyler <benjamin.tyler@booking.com>"
RUN apk add --no-cache ca-certificates
ADD build/shipper-state-metrics.linux-amd64 /bin/shipper-state-metrics
ENTRYPOINT ["shipper-state-metrics"]
