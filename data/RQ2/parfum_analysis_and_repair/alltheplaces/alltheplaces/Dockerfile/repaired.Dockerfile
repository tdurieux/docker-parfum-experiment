FROM python:3.9

RUN pip install --no-cache-dir pipenv
WORKDIR /opt/app

# Used by the run all spiders script to build output JSON
RUN apt-get update \
    && apt-get install --no-install-recommends -y jq \
    && rm -rf /var/lib/apt/lists/*

COPY Pipfile Pipfile
COPY Pipfile.lock Pipfile.lock
RUN pipenv install --dev --deploy --system

COPY . .

CMD ["/opt/app/ci/run_all_spiders.sh"]
