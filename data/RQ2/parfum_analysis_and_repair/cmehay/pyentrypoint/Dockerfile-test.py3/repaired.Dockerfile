# Testing with last python 3

FROM python:3

ENV POETRY_VIRTUALENVS_CREATE=false

RUN pip install --no-cache-dir poetry

RUN adduser --uid 1009 --system testuser
RUN addgroup --gid 1010 testgroup

ENV PYTHONPATH /opt/

COPY tests/test_template.yml.tpl /tmp/test_template.yml
COPY tests/test_template.yml.tpl /tmp/test_template2.yml.tpl
COPY pyproject.toml poetry.lock /opt/

RUN cd /opt && poetry install

WORKDIR /opt/tests

CMD ["pytest", "--verbose", "-rw", "."]
