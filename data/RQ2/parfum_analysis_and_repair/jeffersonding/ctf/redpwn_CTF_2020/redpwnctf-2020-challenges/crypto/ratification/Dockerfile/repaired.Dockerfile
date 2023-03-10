FROM python:3.8-buster

RUN apt-get update && apt-get install --no-install-recommends -y \
    xinetd \
 && rm -rf /var/lib/apt/lists/*

RUN pip3 install --no-cache-dir \
    pycryptodome \
    numpy

COPY ctf.xinetd /etc/xinetd.d/ctf

COPY server.py flag.txt /

CMD ["xinetd", "-dontfork"]

EXPOSE 9999
