FROM docker.io/python:3.10@sha256:eeed7cac682f9274d183f8a7533ee1360a26acb3616aa712b2be7896f80d8c5f

# Support additional root CAs
COPY README.md cert.pem* /certs/
# Debian
RUN if [ -e /certs/cert.pem ]; then cp /certs/cert.pem /etc/ssl/certs/ca-certificates.crt; fi

RUN python3 -m pip install virtualenv

RUN apt-get update && apt-get -y --no-install-recommends install netcat && rm -rf /var/lib/apt/lists/*;

COPY Pipfile.lock Pipfile.lock
COPY Pipfile Pipfile

RUN python3 -m pip install pipenv
RUN pipenv install
RUN mkdir teal

COPY *.py .
COPY test/*.json .
COPY deploy.sh deploy.sh
COPY .env .env
