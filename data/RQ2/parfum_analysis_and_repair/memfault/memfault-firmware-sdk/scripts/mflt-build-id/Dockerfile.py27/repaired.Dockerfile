FROM python:2.7-slim AS base

RUN pip install --no-cache-dir enum34==1.1.10
RUN pip install --no-cache-dir snapshottest==0.5.0
RUN pip install --no-cache-dir pyelftools==0.27
RUN pip install --no-cache-dir pytest==4.6.11

COPY ./ /mflt-build-id/
