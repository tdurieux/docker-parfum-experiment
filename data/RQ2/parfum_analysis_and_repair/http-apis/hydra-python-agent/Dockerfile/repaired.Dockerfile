FROM python:3

LABEL  maintainer="Sandeep Chauhan <sandeepsajan0@gmail.com>"

COPY ./requirements.txt requirements.txt

RUN pip install --no-cache-dir -U pip && pip install --no-cache-dir --upgrade pip setuptools \
    && pip install --no-cache-dir -r requirements.txt

COPY ./hydra_agent /app/hydra_agent

ENV PYTHONPATH $PYTHONPATH:/app

ENV MESSAGE "Hail Hydra"

ENTRYPOINT ["python", "/app/hydra_agent/querying_mechanism.py"]



