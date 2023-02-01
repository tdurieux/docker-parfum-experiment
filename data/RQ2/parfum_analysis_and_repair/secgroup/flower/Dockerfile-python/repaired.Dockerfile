FROM python:2.7

COPY . /app

WORKDIR /app

RUN apt-get update && \
    apt-get install --no-install-recommends -y tcpdump libnet1-dev libpcap-dev tar patch wget && \
    wget "https://github.com/MITRECND/pynids/archive/0.6.2.tar.gz" && \
    tar -xvzf 0.6.2.tar.gz && \
    cd pynids-0.6.2/ && \
    python setup.py build && \
    python setup.py install && \
    cd /app && \
    pip install --no-cache-dir -r services/requirements.txt && rm 0.6.2.tar.gz && rm -rf /var/lib/apt/lists/*;

CMD sleep 3 && \
    find services/test_pcap -name *.pcap -exec python services/importer.py {} \; && \
    python services/webservice.py
