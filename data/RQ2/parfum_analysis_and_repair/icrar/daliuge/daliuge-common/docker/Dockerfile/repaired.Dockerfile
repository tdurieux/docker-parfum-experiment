# we are doing a two-stage build to keep the size of
# the final image low.

# First stage build and cleanup
#FROM python:3.8-slim
FROM ubuntu:20.04
ARG BUILD_ID
LABEL stage=builder
LABEL build=$BUILD_ID
RUN apt-get update && \
    apt-get install --no-install-recommends -y gcc python3 python3.8-venv python3-pip python3-distutils python3-appdirs libmetis-dev curl git sudo && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;

COPY / /daliuge

RUN cd / && python3 -m venv dlg && cd /daliuge && \
    . /dlg/bin/activate && \
    pip install --no-cache-dir wheel numpy && \
    pip install --no-cache-dir .

# we don't clean this up, will be done in the derived images