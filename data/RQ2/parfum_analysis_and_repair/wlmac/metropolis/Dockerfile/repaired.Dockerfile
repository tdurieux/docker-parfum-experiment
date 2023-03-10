FROM python:3.9-slim

LABEL maintainer="Kyunghan (Paul) Lee <contact@paullee.dev>"

RUN apt-get update && apt-get install --no-install-recommends -y gcc python3-dev libpq-dev libffi-dev libssl-dev && rm -rf /var/lib/apt/lists/*;

RUN python3 -m pip install --no-cache-dir psycopg2

WORKDIR /app

COPY requirements.txt /app/

RUN python3 -m pip install -r requirements.txt

COPY . /app/

EXPOSE 8000

CMD ["gunicorn", "metropolis.wsgi", "-b", "0.0.0.0:8000"]
