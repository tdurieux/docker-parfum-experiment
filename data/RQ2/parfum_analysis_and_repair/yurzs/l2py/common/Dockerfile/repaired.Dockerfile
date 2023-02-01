FROM python:3.10.3

ENV PATH $PATH:/root/.local/bin
ENV PYTHONPATH /code
ENV PYTHONBUFFERED 1

ADD common /code/common/
ADD pyproject.toml /code/
ADD bin/sitecustomize.py /code

WORKDIR /code

RUN pip install --no-cache-dir --upgrade pip
RUN apt-get update && apt-get install --no-install-recommends -y build-essential swig && rm -rf /var/lib/apt/lists/*;

RUN curl -f -sSL https://install.python-poetry.org | python3 -

RUN poetry config virtualenvs.in-project true
RUN poetry config experimental.new-installer false
RUN poetry install --no-interaction --no-ansi
