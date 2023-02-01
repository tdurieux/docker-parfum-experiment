FROM python

RUN apt install -y --no-install-recommends git && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir minos-discovery==0.0.8

COPY config.yml ./config.yml
CMD ["discovery", "start", "config.yml"]
