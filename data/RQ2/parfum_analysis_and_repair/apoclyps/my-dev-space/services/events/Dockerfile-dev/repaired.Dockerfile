FROM python:3.7.0

# install environment dependencies
RUN apt-get update -yqq && apt-get install -yqq --no-install-recommends netcat && apt-get -q clean && rm -rf /var/lib/apt/lists/*;

# set working directory
RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

# add requirements
RUN pip install --no-cache-dir pipenv
COPY Pipfile Pipfile.lock /usr/src/app/
RUN pipenv install --deploy --dev --ignore-pipfile --system

# add entrypoint.sh
ADD ./entrypoint.sh /usr/src/app/entrypoint.sh

# add newrelic config
ADD ./newrelic.ini /usr/src/app/newrelic.ini
ENV NEW_RELIC_CONFIG_FILE=newrelic.ini

# run server
CMD ["./entrypoint.sh"]
