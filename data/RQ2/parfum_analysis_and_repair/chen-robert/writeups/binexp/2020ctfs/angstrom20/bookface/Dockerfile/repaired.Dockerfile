FROM ubuntu:xenial

RUN apt-get update && apt-get install --no-install-recommends -y xinetd zsh gdb wget && rm -rf /var/lib/apt/lists/*;
RUN wget -q -O- https://github.com/hugsy/gef/raw/master/scripts/gef.sh | sh

COPY xinetd.conf /etc/xinetd.d/ctf

WORKDIR /ctf
RUN mkdir /ctf/users

COPY bookface .
COPY server.sh .
COPY flag.txt .
RUN chmod +x server.sh
RUN chmod +x bookface
RUN chown -R 1000 /ctf

EXPOSE 1337

ENTRYPOINT ["xinetd", "-dontfork", "-limit", "256"]
