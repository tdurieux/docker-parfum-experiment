FROM python:3

ARG PORT=3000
ARG HAYSTACK_PROVIDER=shaystack.providers.db
ARG HAYSTACK_DB=https://shaystack.s3.eu-west-3.amazonaws.com/carytown.zinc
ARG HAYSTACK_TS
ARG REFRESH=15
ARG STAGE=prod

ARG PIP_INDEX_URL=https://pypi.python.org/pypi
ARG PIP_EXTRA_INDEX_URL

WORKDIR /usr/src/app

ENV PIP_INDEX_URL=${PIP_INDEX_URL}
ENV PIP_EXTRA_INDEX_URL=${PIP_EXTRA_INDEX_URL}

RUN pip install --no-cache-dir "shaystack[flask,graphql,lambda]"

ENV HAYSTACK_PROVIDER=${HAYSTACK_PROVIDER}
ENV HAYSTACK_DB=${HAYSTACK_DB}
ENV HAYSTACK_TS=${HAYSTACK_TS}
ENV REFRESH=${REFRESH}
ENV PORT=${PORT}
EXPOSE ${PORT}
ENTRYPOINT shaystack --port ${PORT} --host 0.0.0.0