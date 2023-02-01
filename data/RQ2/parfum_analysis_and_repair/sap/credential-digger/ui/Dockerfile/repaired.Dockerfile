FROM python:3.9-bullseye as builder

RUN pip install --no-cache-dir flask_jwt_extended Flask python-dotenv
RUN apt-get update && apt-get install --no-install-recommends -y libhyperscan5 libpq-dev gunicorn3 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y dos2unix && rm -rf /var/lib/apt/lists/*;

# Don't verify ssl for github enterprise
RUN git config --global http.sslverify false
# Docker Windows support
RUN git config --global core.autocrlf false

# Install Credential Digger
RUN pip install --no-cache-dir credentialdigger
# Install Gunicorn WSGI HTTP Server
RUN pip install --no-cache-dir gunicorn

ARG SSL_certificate
ARG SSL_private_key

COPY . /credential-digger-ui
WORKDIR /credential-digger-ui/
# Fix possible line-terminators errors
RUN find . -type f -print0 | xargs -0 dos2unix

RUN chmod +x run.sh
CMD [ "./run.sh" ]
