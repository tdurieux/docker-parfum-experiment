FROM python:3.10-slim-buster

ARG VERSION

COPY ./dist /tmp/dist
RUN pip install --no-cache-dir cyclonedx-bom==${VERSION} --find-links file:///tmp/dist
ENTRYPOINT ["cyclonedx-bom"]
