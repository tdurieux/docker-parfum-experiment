FROM golang:bullseye as go-builder

WORKDIR /go/src/app

RUN go install github.com/bemasher/rtlamr@latest \
    && apt-get update \
    && apt-get install --no-install-recommends -y libusb-1.0-0-dev build-essential git cmake \
    && git clone git://git.osmocom.org/rtl-sdr.git \
    && cd rtl-sdr \
    && mkdir build && cd build \
    && cmake .. -DDETACH_KERNEL_DRIVER=ON -DENABLE_ZEROCOPY=ON -Wno-dev \
    && make \
    && make install && rm -rf /var/lib/apt/lists/*;

FROM python:3.10-slim

COPY --from=go-builder /usr/local/lib/librtl* /lib/
COPY --from=go-builder /go/bin/rtlamr* /usr/bin/
COPY --from=go-builder /usr/local/bin/rtl* /usr/bin/
COPY ./rtlamr2mqtt.py /usr/bin
COPY ./requirements.txt /tmp
COPY ./sdl_ids.txt /var/lib/

RUN apt-get update \
    && apt-get install --no-install-recommends -o Dpkg::Options::="--force-confnew" -y \
      libusb-1.0-0 \
    && apt-get --purge autoremove -y \
    && apt-get clean \
    && find /var/lib/apt/lists/ -type f -delete \
    && pip install --no-cache-dir -r /tmp/requirements.txt \
    && chmod 755 /usr/bin/rtlamr2mqtt.py \
    && rm -rf /usr/share/doc /tmp/requirements.txt && rm -rf /var/lib/apt/lists/*;

STOPSIGNAL SIGTERM

ENTRYPOINT ["/usr/bin/rtlamr2mqtt.py"]
