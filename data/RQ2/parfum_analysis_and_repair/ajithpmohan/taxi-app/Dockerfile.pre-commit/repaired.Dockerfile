# pull official base image
FROM python:3.10-slim

ENV BASE_DIR=/usr/src/app
WORKDIR $BASE_DIR

# create the app user
# RUN addgroup -S app && adduser -S app -G app

RUN apt-get update \
    && apt-get install -y --no-install-recommends gcc musl-dev git && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir --upgrade pip

RUN pip install --no-cache-dir pre-commit

# Copies everything over to Docker environment
COPY . $BASE_DIR

# chown all the files to the app user
# RUN chown -R app:app $BASE_DIR

# change to the app user
# USER app

RUN pre-commit install
RUN pre-commit autoupdate
