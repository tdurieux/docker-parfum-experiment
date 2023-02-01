FROM python:3.10-slim-buster

WORKDIR /srv

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

RUN apt update && apt install --no-install-recommends -y libpq-dev build-essential netcat && rm -rf /var/lib/apt/lists/*

COPY ./requirements.txt .
COPY ./requirements-prod.txt .

RUN pip install --no-cache-dir --upgrade pip && pip install --no-cache-dir -r requirements.txt && pip install --no-cache-dir -r requirements-prod.txt

COPY . .

ENTRYPOINT ["./entrypoint.sh"]
CMD ["gunicorn", "incubator.wsgi:application", "--bind", "0.0.0.0:8000"]
