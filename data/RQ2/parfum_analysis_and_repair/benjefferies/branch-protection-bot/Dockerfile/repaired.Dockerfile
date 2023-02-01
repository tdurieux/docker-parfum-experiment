FROM python:3.7-slim-stretch AS base

ENV PYROOT /pyroot
ENV PYTHONUSERBASE $PYROOT


FROM base AS builder

RUN pip install --no-cache-dir pipenv==2020.8.13 && \
    apt-get update -y && \
    apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;

COPY Pipfile* /home/src/

WORKDIR /home/src

RUN PIP_USER=1 PIP_IGNORE_INSTALLED=1 pipenv install --system --deploy --ignore-pipfile

FROM base

COPY --from=builder $PYROOT/lib/ $PYROOT/lib/
COPY run.py /bin

CMD ["run.py"]
