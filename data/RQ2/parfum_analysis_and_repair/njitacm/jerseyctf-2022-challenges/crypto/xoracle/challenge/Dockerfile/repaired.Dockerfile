FROM ubuntu:latest

RUN apt update && apt install --no-install-recommends ncat python3 -y && rm -rf /var/lib/apt/lists/*;

COPY flag.txt /root

COPY xoracle.py /root

RUN chmod +x /root/xoracle.py

ENTRYPOINT ncat -nvlp 9999 -e /root/xoracle.py -k

EXPOSE 9999

