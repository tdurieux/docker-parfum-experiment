FROM python:3.6.8-stretch

ENV PYTHONUNBUFFERED 1
WORKDIR /config
COPY . /web
RUN apt-get update && apt-get install --no-install-recommends -y cron && rm -rf /var/lib/apt/lists/*;
ADD requirements.txt /config/
RUN pip install --no-cache-dir -r requirements.txt

WORKDIR /web
ENTRYPOINT ["/web/docker-entrypoint.sh"]