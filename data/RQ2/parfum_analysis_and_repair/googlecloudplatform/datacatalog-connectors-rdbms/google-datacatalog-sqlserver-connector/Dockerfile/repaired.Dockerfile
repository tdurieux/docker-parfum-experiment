# docker build -t sqlserver2datacatalog .
FROM python:3.7

# Set the GOOGLE_APPLICATION_CREDENTIALS environment variable.
# At run time, /data must be binded to a volume containing a valid Service Account credentials file
# named sqlserver2dc-credentials.json.
ENV GOOGLE_APPLICATION_CREDENTIALS=/data/sqlserver2dc-credentials.json

RUN apt-get update

# install FreeTDS and dependencies
RUN apt-get update \
 && apt-get install --no-install-recommends unixodbc -y \
 && apt-get install --no-install-recommends unixodbc-dev -y \
 && apt-get install --no-install-recommends --reinstall build-essential -y && rm -rf /var/lib/apt/lists/*;

# Debian 10 ODBC DRIVER
RUN curl -f https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
RUN curl -f https://packages.microsoft.com/config/debian/10/prod.list > /etc/apt/sources.list.d/mssql-release.list
RUN apt-get update
RUN ACCEPT_EULA=Y apt-get -y --no-install-recommends install msodbcsql17 && rm -rf /var/lib/apt/lists/*;

# Copy the local client library dependency and install it (temporary).
WORKDIR /lib

RUN pip install --no-cache-dir flake8
RUN pip install --no-cache-dir yapf

WORKDIR /app

# Copy project files (see .dockerignore).
COPY . .

RUN yapf --diff --recursive src tests
RUN flake8 src tests

# Install google-datacatalog-sqlserver-connector package from source files.
RUN pip install --no-cache-dir .

RUN python setup.py test

ENTRYPOINT ["google-datacatalog-sqlserver-connector"]
