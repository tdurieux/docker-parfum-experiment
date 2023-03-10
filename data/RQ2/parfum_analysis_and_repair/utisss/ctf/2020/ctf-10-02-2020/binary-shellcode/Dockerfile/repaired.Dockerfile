FROM ubuntu:16.04

RUN apt-get update
RUN apt-get update && apt-get install --no-install-recommends -y build-essential socat libseccomp-dev && rm -rf /var/lib/apt/lists/*;


ARG USER
ENV USER $USER

WORKDIR /

COPY ./shellcode /

COPY start.sh /start.sh
RUN chmod 755 /start.sh

RUN useradd -m $USER

EXPOSE 9000

CMD ["/start.sh"]


