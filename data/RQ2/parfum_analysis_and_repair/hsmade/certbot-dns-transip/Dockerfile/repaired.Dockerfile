FROM python:3.9
RUN pip install --no-cache-dir certbot-dns-transip
ENTRYPOINT ["certbot"]
