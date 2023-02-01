FROM python:3.6

RUN pip install --no-cache-dir pipenv

RUN apt-get install -y --no-install-recommends libpq-dev && rm -rf /var/lib/apt/lists/*;

RUN mkdir /app && cd /app

WORKDIR /app

COPY Pipfile Pipfile
COPY Pipfile.lock Pipfile.lock

RUN pipenv install --deploy --system

COPY gdq_collector gdq_collector

CMD python -m gdq_collector
