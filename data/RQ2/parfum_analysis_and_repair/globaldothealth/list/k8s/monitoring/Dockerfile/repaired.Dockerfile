FROM python:3.10
ENV PIP_DISABLE_PIP_VERSION_CHECK=on
RUN apt-get update && apt-get -y --no-install-recommends install awscli && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir poetry
WORKDIR /app
COPY poetry.lock pyproject.toml /app/
RUN poetry config virtualenvs.create false
RUN poetry install --no-interaction --no-dev
COPY run_kubemon.sh kubemon.py /app/
ENTRYPOINT ["/app/run_kubemon.sh"]
