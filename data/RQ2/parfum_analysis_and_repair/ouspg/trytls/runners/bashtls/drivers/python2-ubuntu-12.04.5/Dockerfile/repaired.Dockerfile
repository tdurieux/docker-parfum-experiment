FROM ubuntu:12.04.5

RUN apt-get -y update && \
  apt-get -y --no-install-recommends install \
  python \
  python-pip && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir \
  requests \
  urllib3 \
  certifi

CMD bash '/etc/shared/scripts/drive'
#CMD cat /stubs/python3-urllib/run.py
