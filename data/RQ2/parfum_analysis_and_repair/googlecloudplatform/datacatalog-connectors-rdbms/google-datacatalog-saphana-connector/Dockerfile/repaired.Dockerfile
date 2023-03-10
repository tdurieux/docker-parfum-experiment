# docker build -t saphana2datacatalog .
FROM python:3.7

# Set the GOOGLE_APPLICATION_CREDENTIALS environment variable.
# At run time, /data must be binded to a volume containing a valid Service Account credentials file
# named saphana2dc-credentials.json.
ENV GOOGLE_APPLICATION_CREDENTIALS=/data/saphana2dc-credentials.json

RUN apt-get update


# Copy the local client library dependency and install it (temporary).
WORKDIR /lib

RUN pip install --no-cache-dir flake8
RUN pip install --no-cache-dir yapf

WORKDIR /app

# Copy project files (see .dockerignore).
COPY . .

RUN yapf --diff --recursive src tests
RUN flake8 src tests

# Install google-datacatalog-saphana-connector package from source files.
RUN pip install --no-cache-dir .

RUN python setup.py test

ENTRYPOINT ["google-datacatalog-saphana-connector"]
