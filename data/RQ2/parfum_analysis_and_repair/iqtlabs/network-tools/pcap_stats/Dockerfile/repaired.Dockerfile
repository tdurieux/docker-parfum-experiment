FROM python:3.10-slim
LABEL maintainer="Charlie Lewis <clewis@iqt.org>"

ENV DEBIAN_FRONTEND noninteractive
ENV PYTHONUNBUFFERED 1
ENV PYTHONPATH=/app/network_tools_lib

WORKDIR /app
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    python3-enchant tshark whois && \
    rm -rf /root/* && rm -rf /var/lib/apt/lists/*;

COPY pcap_stats/requirements.txt /app/requirements.txt
COPY network_tools_lib /app/network_tools_lib
COPY pcap_stats/nmap-mac-prefixes.txt /app/nmap-mac-prefixes.txt
COPY pcap_stats/asn.sh /app/asn.sh
COPY pcap_stats/pcap_stats.py /app/pcap_stats.py
RUN pip3 install --no-cache-dir -r /app/requirements.txt
RUN python3 /app/pcap_stats.py

ENTRYPOINT ["python3", "/app/pcap_stats.py"]
CMD [""]
