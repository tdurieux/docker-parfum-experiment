FROM python:3.9-slim

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    curl \
    git \
    && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN curl -f -sL https://deb.nodesource.com/setup_12.x | bash - && \
    apt-get install --no-install-recommends -y nodejs && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN curl -f -LJ https://github.com/krallin/tini/releases/download/v0.19.0/tini -o /usr/bin/tini && \
    chmod +x /usr/bin/tini

RUN pip install --no-cache-dir \
    histomicsui \
    large_image[sources] \
    girder-homepage \


    girder-client \
    --find-links https://girder.github.io/large_image_wheels

RUN girder build

COPY girder.cfg /etc/.
COPY provision.py .

ENTRYPOINT ["/usr/bin/tini", "--"]

CMD python provision.py --sample-data && girder serve --database mongodb://mongodb:27017/girder
