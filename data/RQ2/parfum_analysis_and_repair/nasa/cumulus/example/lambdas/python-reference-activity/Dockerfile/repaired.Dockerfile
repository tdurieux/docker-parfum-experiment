FROM python:3.7-buster
ADD . /source
WORKDIR /source
RUN pip install --no-cache-dir pipenv && pipenv install --system --deploy --ignore-pipfile
