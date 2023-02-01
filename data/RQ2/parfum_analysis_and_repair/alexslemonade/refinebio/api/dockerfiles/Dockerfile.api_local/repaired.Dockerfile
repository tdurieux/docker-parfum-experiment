FROM python:3.8.5-slim-buster

# Install libpq-dev for psycopg2
RUN apt-get update -qq && apt-get install --no-install-recommends -y libpq-dev gcc && rm -rf /var/lib/apt/lists/*;

RUN groupadd user && useradd --create-home --home-dir /home/user -g user user
WORKDIR /home/user

RUN pip install --no-cache-dir --upgrade pip

COPY config/ config/

COPY api/requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

COPY common/dist/data-refinery-common-* common/

# Get the latest version from the dist directory.
RUN pip install --no-cache-dir \
    common/$(ls common -1 | sort --version-sort | tail -1)

COPY api/ .

ARG SYSTEM_VERSION

ENV SYSTEM_VERSION $SYSTEM_VERSION

USER user

EXPOSE 8000

ENTRYPOINT []
