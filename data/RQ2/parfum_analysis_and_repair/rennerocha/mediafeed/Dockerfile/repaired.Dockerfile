FROM python:3.7

# Install poetry
ENV POETRY_HOME="/opt/poetry"
ENV PATH="$POETRY_HOME/bin:$PATH"
RUN curl -f -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python
RUN apt-get update && apt-get install --no-install-recommends -y cron && rm -rf /var/lib/apt/lists/*;

COPY poetry.lock pyproject.toml /
RUN poetry config virtualenvs.create false && poetry install --no-dev

COPY start_app.sh /

ENV APP_ROOT /mediafeed

RUN mkdir ${APP_ROOT}
WORKDIR ${APP_ROOT}

EXPOSE 8000
ADD mediafeed/ ${APP_ROOT}

CMD ["gunicorn", "--bind", "0.0.0.0:8000", "mediafeed.wsgi"]
