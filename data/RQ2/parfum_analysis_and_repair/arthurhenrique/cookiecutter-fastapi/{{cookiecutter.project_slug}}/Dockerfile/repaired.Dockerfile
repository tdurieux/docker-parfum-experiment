FROM python:3.9.2

ENV PYTHONUNBUFFERED 1

EXPOSE 8080
WORKDIR /app

COPY poetry.lock pyproject.toml ./
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir poetry && \
    poetry config virtualenvs.create false && \
    poetry install --no-dev

COPY . ./
ENV PYTHONPATH app
ENTRYPOINT ["python", "app/main.py"]