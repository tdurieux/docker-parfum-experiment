FROM ubuntu:14.04

RUN apt-get update && apt-get install --no-install-recommends -q -y tcpdump python-enum python-pyasn1 scapy python-crypto python-pip python && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir scapy-ssl_tls

ADD pyx509 pyx509
ADD scapy_ssl_tls scapy_ssl_tls
ADD scanner.py scanner.py

ENTRYPOINT ["/usr/bin/env", "python", "scanner.py"]
CMD ["localhost", "443"]
