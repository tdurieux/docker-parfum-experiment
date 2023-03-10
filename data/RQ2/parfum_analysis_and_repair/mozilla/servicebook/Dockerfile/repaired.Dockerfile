# Servicebook
FROM python:3-slim

RUN apt-get update && apt-get install --no-install-recommends -y git build-essential make libssl-dev libffi-dev python3-dev python3-venv && rm -rf /var/lib/apt/lists/*;
RUN addgroup --gid 10001 app
RUN adduser --gid 10001 --uid 10001 --home /app --shell /sbin/nologin --no-create-home --disabled-password --gecos we,dont,care,yeah app

WORKDIR /app
COPY requirements/pipenv.txt /app/requirements/
RUN pip install --no-cache-dir -r requirements/pipenv.txt uwsgi
COPY . /app
RUN pipenv install --deploy --system

RUN chown 10001:10001 -R /app

COPY version.json /app/version.json

USER app
EXPOSE 5001
ENTRYPOINT ["/app/entrypoint.sh"]
CMD ["start"]
