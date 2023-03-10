FROM python:3.7

RUN pip install --no-cache-dir --upgrade pip

RUN useradd -m worker
WORKDIR /project
# It is a real shame that WORKDIR doesn't honor the current user (or even take a chown option), so.....
RUN chown worker:worker /project
USER worker

RUN pip install --no-cache-dir --upgrade --user pipenv
ENV PATH=/home/worker/.local/bin:$PATH

ENV APPSODY_MOUNTS=/:/project/userapp
ENV APPSODY_DEPS=/project/deps
# This (and the project) Dockerfile already ensure we run as worker, rather than root - so don't enable running as the local
# user, since this would cause a clash of two different UIDs
ENV APPSODY_USER_RUN_AS_LOCAL=false

ENV APPSODY_WATCH_DIR=/project/userapp
ENV APPSODY_WATCH_REGEX="^.*.py$"

ENV APPSODY_PREP="cd /project/userapp;pipenv lock -r > ../requirements-additional.txt;python -m pip install -r ../requirements-additional.txt -t /project/deps"

ENV APPSODY_RUN="python -m flask run --host=0.0.0.0 --port=8080"
ENV APPSODY_RUN_ON_CHANGE=$APPSODY_RUN
ENV APPSODY_RUN_KILL=true

ENV APPSODY_DEBUG="FLASK_ENV=development python -m ptvsd --host 0.0.0.0 --port 5678 -m flask run --host=0.0.0.0 --port=8080 --no-reload"
ENV APPSODY_DEBUG_ON_CHANGE=$APPSODY_DEBUG
ENV APPSODY_DEBUG_KILL=true

ENV APPSODY_TEST="python -m unittest discover -s test -p *.py"
ENV APPSODY_TEST_ON_CHANGE=$APPSODY_TEST
ENV APPSODY_TEST_KILL=false

COPY --chown=worker:worker ./LICENSE /licenses/
COPY --chown=worker:worker ./project /project
COPY --chown=worker:worker ./config /config

RUN pipenv lock -r > requirements.txt
RUN python -m pip install -r requirements.txt -t /project/deps
RUN python -m pip install ptvsd -t /project/deps

# The next line gets round a problem with flasgger in that it has an unnecessary requirement on
# jsonschema of < 3.0.0, while other components here need > 3.0.0. This is fixed in flasgger
# PR 317, but a new release has not yet been pushed to pypi. The line below and the constraints
# file can be removed once a new release is made (and flassger added to the regular Pipfile).
# This constraints workaround will still cause an error on docker build, but this can be ignored.
RUN python -m pip install --upgrade -c constraints.txt flasgger==0.9.3 -t /project/deps

ENV PYTHONPATH=/project/deps
ENV FLASK_APP=/project/server/__init__.py

ENV PORT=8080
EXPOSE 8080
EXPOSE 5678
