FROM python:3.8

COPY pyproject.toml DESCRIPTION.rst mtv_dl.py /
RUN pip3 install --no-cache-dir poetry
RUN poetry install --no-dev

RUN mkdir /data
VOLUME /data
WORKDIR /data

ENTRYPOINT ["poetry", "run", "mtv_dl"]
