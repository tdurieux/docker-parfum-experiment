FROM python:3.5

WORKDIR /dd_crawler

RUN apt-get update && \
    apt-get install --no-install-recommends -y dnsmasq redis-tools && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir -U pip setuptools wheel && \
    pip install --no-cache-dir numpy pandas scrapy

COPY ./requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt && \
    formasaurus init

COPY ./docker/deep-deep-0.0.tar.gz .
RUN pip install --no-cache-dir deep-deep-0.0.tar.gz

COPY ./docker/dnsmasq.conf /etc/
COPY ./docker/resolv.dnsmasq /etc/

COPY . .

RUN pip install --no-cache-dir -e .

ENTRYPOINT /bin/bash /dd_crawler/docker/crawl.sh
