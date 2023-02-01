FROM python:3.8-slim-buster AS uwsgi

ENV PYTHONUNBUFFERED 1
WORKDIR /app

RUN apt-get -y update && apt-get install --no-install-recommends -y gcc && rm -rf /var/lib/apt/lists/*;

COPY requirements.txt /app/requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

COPY . /app

EXPOSE 8000

CMD uwsgi --ini uwsgi.ini
