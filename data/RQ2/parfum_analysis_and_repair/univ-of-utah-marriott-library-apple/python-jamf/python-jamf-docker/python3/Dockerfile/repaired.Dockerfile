FROM python:3
RUN pip install --no-cache-dir keyrings.alt
ENTRYPOINT /bin/bash