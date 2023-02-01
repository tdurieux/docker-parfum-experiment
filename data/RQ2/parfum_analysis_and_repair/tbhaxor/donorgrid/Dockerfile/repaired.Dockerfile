FROM python:3-alpine3.14

RUN mkdir /app
WORKDIR /app

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

RUN pip install --no-cache-dir -U pip

RUN apk update && apk add --no-cache gcc musl-dev libffi-dev postgresql postgresql-dev rust cargo

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

RUN chmod +x ./entrypoint.sh

ENTRYPOINT ["/app/entrypoint.sh"]