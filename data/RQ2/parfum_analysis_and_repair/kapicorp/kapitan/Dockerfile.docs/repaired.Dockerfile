FROM squidfunk/mkdocs-material:7.1.2

COPY requirements.docs.txt /tmp/requirements.docs.txt

RUN apk update && \
    pip install --no-cache-dir -r /tmp/requirements.docs.txt
