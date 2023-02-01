FROM debian:latest

RUN apt-get update && apt-get install --no-install-recommends -y \
    python-sphinx \
    build-essential \
    python-sphinx-rtd-theme \
    && rm -rf /var/lib/apt/lists/*
RUN pip install --no-cache-dir -r /docbuild/requirements.txt

RUN mkdir -p /docbuild

CMD make -C /docbuild html
