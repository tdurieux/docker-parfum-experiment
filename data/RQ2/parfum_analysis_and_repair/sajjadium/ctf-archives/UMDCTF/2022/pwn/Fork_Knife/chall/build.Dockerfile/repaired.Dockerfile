FROM ubuntu:20.04

RUN apt update -y && apt install --no-install-recommends -y \
    gcc make && rm -rf /var/lib/apt/lists/*;

COPY ./src/ /root/

WORKDIR /root
RUN make

CMD ["/bin/bash", "-i"]
