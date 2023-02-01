FROM python:3.6-alpine

RUN pip3 install --no-cache-dir goutte

ENV GOUTTE_CONFIG goutte.toml
ENV GOUTTE_DO_TOKEN ''

WORKDIR /goutte

ENTRYPOINT ["goutte"]
