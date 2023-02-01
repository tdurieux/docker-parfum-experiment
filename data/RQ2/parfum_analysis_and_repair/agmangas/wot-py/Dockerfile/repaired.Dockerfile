FROM python:3.7
ENV PATH_APP /app

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y tshark && \
    groupadd wireshark && \
    usermod -aG wireshark root && \
    setcap 'CAP_NET_RAW+eip CAP_NET_ADMIN+eip' /usr/bin/dumpcap && \
    chgrp wireshark /usr/bin/dumpcap && \
    chmod 750 /usr/bin/dumpcap && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p ${PATH_APP}
WORKDIR ${PATH_APP}
COPY . .
RUN pip install --no-cache-dir -U .
WORKDIR ${PATH_APP}/examples/benchmark
RUN pip install --no-cache-dir -r requirements.txt
WORKDIR ${PATH_APP}