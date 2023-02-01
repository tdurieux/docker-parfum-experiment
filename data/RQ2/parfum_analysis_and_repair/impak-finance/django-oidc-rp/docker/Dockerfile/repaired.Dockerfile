FROM python:3.9.10-buster

ENV SHELL=/bin/bash
ENV PYTHONUNBUFFERED 1

RUN apt update
RUN apt-get install --no-install-recommends -y binutils libproj-dev gdal-bin && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y binutils libproj-dev gdal-bin xmlsec1 python3-dev libssl-dev libsasl2-dev twine && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir -U pip setuptools wheel

COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]