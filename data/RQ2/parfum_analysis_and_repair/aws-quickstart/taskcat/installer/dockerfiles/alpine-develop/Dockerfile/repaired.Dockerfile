FROM python:3.9.12-alpine3.15

LABEL maintainer="Tony Vattathil tonynv@amazon.com"

# Version
LABEL version=production

# Operating Systems
LABEL container-os=python

RUN apt update && apt install --no-install-recommends -y gcc && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir taskcat --upgrade \
&& pip3 install --index-url https://test.pypi.org/simple/ taskcat  --no-cache-dir --force --upgrade --no-deps

# Set the work directory
WORKDIR /mnt
