FROM ubuntu:19.04

RUN apt-get update && apt-get install --no-install-recommends socat -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get dist-upgrade -y


COPY libc64_2.29.so /lib/x86_64-linux-gnu/libc-2.29.so
COPY ld64_2.29.so /lib64/ld-linux-x86-64.so.2

RUN useradd -m hello
COPY helloworld flag /home/hello/
RUN chown -R root:hello /home/hello
RUN chmod -R 750 /home/hello/
EXPOSE 4444
USER hello
CMD socat -T30 TCP-LISTEN:4444,reuseaddr,fork EXEC:/home/hello/helloworld
