FROM ubuntu:16.04

RUN apt-get update
RUN apt-get update && apt-get install --no-install-recommends -y build-essential socat libseccomp-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python3 && rm -rf /var/lib/apt/lists/*;

ARG USER
ENV USER $USER

COPY ./start.sh /start.sh
COPY ./run.py /run.py
COPY ./valid.txt /valid.txt
COPY ./invalid.txt /invalid.txt
COPY ./flag.txt /flag.txt

RUN useradd -m $USER

RUN chmod 755 /start.sh

EXPOSE 9000

CMD ["/start.sh"]
