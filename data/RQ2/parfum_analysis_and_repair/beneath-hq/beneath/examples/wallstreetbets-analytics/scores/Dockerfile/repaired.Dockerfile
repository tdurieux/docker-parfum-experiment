FROM python:3.8
RUN pip install --no-cache-dir poetry==1.1.4
WORKDIR /app
COPY poetry.lock pyproject.toml /app/
RUN poetry config virtualenvs.create false \
  && poetry install --no-dev --no-interaction --no-ansi
COPY . .
ENTRYPOINT ["python", "get_scores.py"]
