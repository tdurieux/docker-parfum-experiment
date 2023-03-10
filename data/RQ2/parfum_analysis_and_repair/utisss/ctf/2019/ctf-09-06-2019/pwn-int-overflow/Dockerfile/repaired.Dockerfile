FROM ubuntu:16.04

RUN apt-get update
RUN apt-get update && apt-get install --no-install-recommends -y build-essential socat libseccomp-dev && rm -rf /var/lib/apt/lists/*;

WORKDIR /app
COPY src/. ./src/.
COPY Makefile .
RUN make
RUN cp prog.o /pwnable

WORKDIR /
RUN rm -rf /app/src

COPY start.sh /start.sh
RUN chmod 755 /start.sh

RUN useradd -m intoverflow

EXPOSE 9000

CMD ["/start.sh"]
