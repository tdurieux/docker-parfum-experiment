# Dockerfile for fittrak python app

FROM python:3

ENV PYTHONUNBUFFERED=1

WORKDIR /usr/src/app

# Required psql deps
RUN apt-get update \
  && apt-get install --no-install-recommends postgresql-client -y \
  && pip install --no-cache-dir pip -U \
  && pip install --no-cache-dir pipenv && rm -rf /var/lib/apt/lists/*;

COPY Pipfile Pipfile.lock . ./

RUN pipenv install --system --ignore-pipfile

EXPOSE 8000

CMD ["sh", "scripts/start.sh"]
