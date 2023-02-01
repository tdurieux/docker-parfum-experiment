FROM ubuntu:14.04

RUN apt-get update && apt-get install --no-install-recommends -y python python-crypto socat && rm -rf /var/lib/apt/lists/*;
COPY ./baby_crypt.py /opt/baby_crypt.py
RUN chmod +x /opt/baby_crypt.py

CMD socat -T60 TCP-LISTEN:8000,reuseaddr,fork EXEC:"python -u /opt/baby_crypt.py"
