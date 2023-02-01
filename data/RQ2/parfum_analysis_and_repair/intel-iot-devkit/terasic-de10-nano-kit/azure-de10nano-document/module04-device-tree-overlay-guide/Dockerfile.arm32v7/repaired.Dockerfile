FROM arm32v7/ubuntu:xenial AS base

WORKDIR /app

COPY overlay.sh /app

COPY new-overlay.rbf /lib/firmware/
COPY new-overlay.dtbo /lib/firmware/

CMD ["./overlay.sh"]