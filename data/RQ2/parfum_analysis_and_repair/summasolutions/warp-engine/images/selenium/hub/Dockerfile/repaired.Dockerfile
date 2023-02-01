FROM selenium/hub

USER root

RUN apt-get update \
    && apt-get install --no-install-recommends -y \
    python3 \
    python3-pip && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir \
    selenium \
    pyyaml \
    requests

RUN rm -rf /var/www/html/* \
  && rm -rf /var/lib/apt/lists/*

COPY scripts/wait-for-grid.sh /opt/bin/wait-for-grid.sh

RUN chmod +x /opt/bin/wait-for-grid.sh

USER seluser

WORKDIR /selenium

EXPOSE 4444