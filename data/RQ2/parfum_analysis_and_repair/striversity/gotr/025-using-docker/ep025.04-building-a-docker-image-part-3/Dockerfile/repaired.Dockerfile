FROM ubuntu

RUN echo "Hello, World!"

RUN apt update && apt install --no-install-recommends -y tree vim htop curl && rm -rf /var/lib/apt/lists/*;

WORKDIR /root
RUN mkdir a && mkdir b && mkdir -p overlay/now

EXPOSE 8000

RUN mkdir -p /data
VOLUME [ "/data" ]

ADD app .

ENTRYPOINT [ "./app", "-p", "8000" ]