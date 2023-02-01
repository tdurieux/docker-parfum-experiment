FROM python:slim-bullseye

WORKDIR /app

COPY app/requirements.txt /app

RUN set -x \
      && apt-get update \
      && apt-get install --no-install-recommends -y gcc libpq-dev \
      && pip install --no-cache-dir -r requirements.txt \
      && apt-get purge -y --auto-remove gcc && rm -rf /var/lib/apt/lists/*;

COPY app/ /app/

CMD [ "python", "/app/app.py"]
