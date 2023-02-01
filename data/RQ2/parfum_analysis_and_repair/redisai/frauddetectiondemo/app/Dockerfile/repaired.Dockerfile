FROM python:3.9

WORKDIR /app
ADD . /app

RUN set -ex; \
    pip install --no-cache-dir --trusted-host pypi.python.org --trusted-host --trusted-host -r requirements.txt;

ENTRYPOINT [ "python3" ]
