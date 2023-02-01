FROM python:3.10

RUN apt-get update && apt-get install --no-install-recommends -y postgresql-client && rm -rf /var/lib/apt/lists/*;

COPY Pipfile Pipfile
COPY Pipfile.lock Pipfile.lock

RUN pip install --no-cache-dir pipenv
RUN pipenv install --system --dev
