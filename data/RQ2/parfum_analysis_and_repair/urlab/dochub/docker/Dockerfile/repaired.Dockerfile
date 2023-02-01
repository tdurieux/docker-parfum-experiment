FROM python:3.10-slim-buster

WORKDIR /srv

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

RUN apt update && apt install --no-install-recommends -y libpq-dev build-essential netcat git libmagic-dev && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir --upgrade pip

COPY ./requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

ENTRYPOINT ["./docker/entrypoint.sh"]
