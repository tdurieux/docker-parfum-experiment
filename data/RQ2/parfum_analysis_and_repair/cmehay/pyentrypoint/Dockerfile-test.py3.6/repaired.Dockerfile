# Testing with python 3.6

FROM python:3.6

ENV POETRY_VIRTUALENVS_CREATE=false

RUN pip install --no-cache-dir poetry

RUN adduser --uid 1009 --system testuser
RUN addgroup --gid 1010 testgroup

ENV PYTHONPATH /opt/

ADD tests/test_template.yml.tpl /tmp/test_template.yml
ADD tests/test_template.yml.tpl /tmp/test_template2.yml.tpl
COPY pyproject.toml poetry.lock /opt/

RUN cd /opt && poetry install


WORKDIR /opt/tests


CMD ["pytest", "--verbose", "-rw", "."]
