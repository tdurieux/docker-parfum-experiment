# docker build -t nullptr . && docker run -p 1024:1024 --rm -it nullptr

FROM ubuntu:19.10

RUN apt-get update && apt-get install --no-install-recommends -y gdb && rm -rf /var/lib/apt/lists/*;
RUN useradd -d /home/ctf/ -m -p ctf -s /bin/bash ctf
RUN echo "ctf:ctf" | chpasswd

WORKDIR /home/ctf

COPY nullptr .
COPY flag .
COPY ynetd .

RUN chmod +x ./ynetd ./nullptr
USER ctf

CMD ./ynetd ./nullptr
