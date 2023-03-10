FROM python:3-alpine

RUN pip install --no-cache-dir mkdocs mkdocs-material && \
    mkdir /docs

WORKDIR /docs

ENTRYPOINT ["mkdocs"]
CMD ["serve", "--dev-addr=0.0.0.0:8000"]
