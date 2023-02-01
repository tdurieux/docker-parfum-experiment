FROM resin/rpi-raspbian
MAINTAINER alexellis2@gmail.com
ENTRYPOINT []

RUN mkdir -p /root/scroll-phat
WORKDIR /root/scroll-phat/

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       python-dev \
       python-smbus \
       i2c-tools \
       python-pip \
       gcc && rm -rf /var/lib/apt/lists/*;

COPY ./examples  ./examples
COPY ./library   ./library
COPY ./tools     ./tools

RUN cd library && python setup.py install

CMD ["python"]
