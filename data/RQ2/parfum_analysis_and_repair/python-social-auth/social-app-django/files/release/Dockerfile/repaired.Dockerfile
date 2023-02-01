FROM python:3.8.2-slim-buster

RUN apt-get update && \
    apt-get install -y --no-install-recommends make gettext git curl && \
    pip install --no-cache-dir -U pip && \
    pip install --no-cache-dir -U setuptools && \
    pip install --no-cache-dir -U twine && rm -rf /var/lib/apt/lists/*;

COPY ./files/release/pypirc.template /
COPY ./files/release/entrypoint.sh /
ADD . /code

WORKDIR /code

ENTRYPOINT ["/entrypoint.sh"]
