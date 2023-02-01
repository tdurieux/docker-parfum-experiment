FROM ubuntu

RUN apt update && apt install --no-install-recommends -y git gcc make libpcap-dev \

RUN git clone https://github.com/AstroTech/ecosystem-example-c /tmp \
    && cd /tmp \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
    && make \
    && make install && rm -rf /var/lib/apt/lists/*;


## -----


FROM alpine

RUN apk add --no-cache git gcc musl-dev libpcap-dev make

RUN git clone https://github.com/AstroTech/ecosystem-example-c /tmp \
    && cd /tmp \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
    && make \
    && make install
