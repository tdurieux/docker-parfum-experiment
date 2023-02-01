FROM python:3.10-slim
ENV PYTHONUNBUFFERED 1

WORKDIR /app/{{cookiecutter.project_name}}

RUN pip install --no-cache-dir poetry

COPY pyproject.toml .
COPY poetry.lock .

RUN poetry export -o requirements.txt

RUN pip install --no-cache-dir --no-deps -r requirements.txt

COPY . .