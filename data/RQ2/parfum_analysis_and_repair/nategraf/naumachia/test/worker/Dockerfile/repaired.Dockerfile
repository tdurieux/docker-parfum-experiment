FROM ubuntu:latest

RUN apt-get update && \
    apt-get install --no-install-recommends -y openvpn iputils-ping curl tcpdump ettercap-text-only nmap arping arp-scan udhcpc python3 telnet yersinia dnsutils python3 python3-pip && rm -rf /var/lib/apt/lists/*;

COPY ./requirements.txt /app/requirements.txt
RUN pip3 install --no-cache-dir -r /app/requirements.txt

RUN mkdir -p /dev/net &&\
    mknod /dev/net/tun c 10 200

COPY . /app

EXPOSE 32678-65535/udp
CMD ["python3", "/app/worker.py"]
