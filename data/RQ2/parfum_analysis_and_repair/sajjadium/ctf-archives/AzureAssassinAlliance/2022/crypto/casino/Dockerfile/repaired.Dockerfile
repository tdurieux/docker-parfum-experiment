# sudo docker build -t aaacasino:latest .
# sudo docker run -p 19991:19991 aaacasino:latest
FROM ubuntu:20.04

RUN apt-get -qq update && apt-get install -y -qq --no-install-recommends xinetd python3-pip && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir pycryptodome
RUN pip3 install --no-cache-dir qunetsim
RUN apt-get install -y -qq --no-install-recommends netcat && rm -rf /var/lib/apt/lists/*;

COPY main.py /
COPY backend.py /
COPY players.py /
COPY casino.py /
COPY secret.py /
COPY service.conf /
COPY wrapper /


RUN chmod +x /main.py /backend.py /players.py /casino.py /secret.py
RUN chmod +x /service.conf /wrapper

EXPOSE 19991

CMD ["/usr/sbin/xinetd", "-filelog", "/dev/stderr", "-dontfork", "-f", "/service.conf"]
