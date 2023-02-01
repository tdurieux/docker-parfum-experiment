FROM python:3.8-slim-buster AS builder

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        gcc \
        libmagickwand-dev && \
    pip install --no-cache-dir pipenv && rm -rf /var/lib/apt/lists/*;

COPY ./Pipfile ./Pipfile.lock ./

ENV PIPENV_VENV_IN_PROJECT=1
RUN pipenv install --deploy

FROM python:3.8-slim-buster

RUN apt-get update && \
    apt-get -y --no-install-recommends install libmagickwand-6.q16-6 && rm -rf /var/lib/apt/lists/*;

COPY --from=builder .venv .venv

ADD ./pjuu ./pjuu

ENV PATH="$PATH:/.venv/bin"
EXPOSE 8000

ENTRYPOINT ["gunicorn"]
CMD ["-b", "0.0.0.0:8000", "-k", "gevent", "pjuu.wsgi:application"]
