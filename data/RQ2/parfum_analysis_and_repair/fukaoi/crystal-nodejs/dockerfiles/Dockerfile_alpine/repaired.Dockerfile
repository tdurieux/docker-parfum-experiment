FROM crystallang/crystal:0.35.1-alpine as builder

RUN apk update
RUN apk add --update --no-cache curl \
    make \
    python \
    g++ \
    gcc \
    gcc-doc \
    linux-headers \
    libc6-compat

RUN ln -s /lib/libc.musl-x86_64.so.1 /lib/ld-linux-x86-64.so.2

ADD ./ /
RUN make nodejs

RUN /lib/x86_64-linux-gnu/libc.so.6
RUN echo "completed"