FROM ubuntu:16.04

RUN apt-get update
RUN apt-get update && apt-get install --no-install-recommends -y build-essential socat libseccomp-dev && rm -rf /var/lib/apt/lists/*;

WORKDIR /

COPY ./graveyard /
COPY ./flag.txt /

COPY start.sh /start.sh
RUN chmod 755 /start.sh

EXPOSE 9000

CMD ["/start.sh"]


