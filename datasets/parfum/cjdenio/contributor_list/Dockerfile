FROM python:3.8-alpine

WORKDIR /usr/src/app

RUN apk --no-cache add curl git \
    && curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python

ENV PATH="/root/.poetry/bin:${PATH}"

COPY . /usr/src/app

RUN poetry config virtualenvs.create false \
    && poetry install --no-root --no-dev -n

CMD ["python", "/usr/src/app/contributor_list/main.py"]
