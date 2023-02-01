FROM python:3.10-slim-buster

# copy files
COPY . /opera
WORKDIR /opera

# install requirements
RUN apt-get update \
    && apt-get install --no-install-recommends -y git-all \
    && pip install --no-cache-dir --upgrade pip wheel \
    && pip install --no-cache-dir . && rm -rf /var/lib/apt/lists/*;

ENTRYPOINT ["opera", "--version", "/dev/null"]
