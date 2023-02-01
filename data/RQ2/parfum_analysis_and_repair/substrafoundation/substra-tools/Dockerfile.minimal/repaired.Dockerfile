FROM nvidia/cuda:9.2-base-ubuntu18.04

ADD ./setup.py /tmp
ADD ./README.md /tmp
ADD ./substratools /tmp/substratools

RUN apt-get update; \
    apt-get install --no-install-recommends -y python3-minimal python3-pip; rm -rf /var/lib/apt/lists/*; \
    cd /tmp && pip3 install --no-cache-dir .; \
    apt-get remove -y python3-pip --purge --autoremove; \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/

WORKDIR /sandbox
ENV PYTHONPATH /sandbox
