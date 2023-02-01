FROM python:3.10-alpine

COPY . /app
WORKDIR /app

RUN pip install --no-cache-dir --upgrade pip && pip install --no-cache-dir pipenv && pipenv install --dev

CMD ["pipenv", "run", "pytest"]
