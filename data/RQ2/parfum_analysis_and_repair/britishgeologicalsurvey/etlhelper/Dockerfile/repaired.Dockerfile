FROM python:3.6.9-slim

# Install package dependencies
RUN apt-get update -y && \
    apt-get install --no-install-recommends -y \
     apt-transport-https \
     build-essential \
     curl \
     git \
     libaio1 && rm -rf /var/lib/apt/lists/*;

# Add repo for Microsoft ODBC driver for SQL Server
RUN curl -f https://packages.microsoft.com/keys/microsoft.asc > microsoft.asc && \
    apt-key add microsoft.asc && \
    curl -f https://packages.microsoft.com/config/debian/9/prod.list > /etc/apt/sources.list.d/mssql-release.list && \
    apt-get update -y && \
    ACCEPT_EULA=y apt-get --no-install-recommends install -y \
      msodbcsql17 \
      unixodbc-dev && rm -rf /var/lib/apt/lists/*;

# Install Python modules
ENV APP=/app
ENV PYTHONPATH=$APP
WORKDIR $APP
RUN mkdir etlhelper

# Install requirements
COPY requirements.txt $APP/
RUN pip install --no-cache-dir -r requirements.txt

# Copy app files to container
COPY setup.py versioneer.py setup.cfg .flake8 .coveragerc README.md pytest.ini $APP/
COPY etlhelper/ $APP/etlhelper
COPY test/ $APP/test

# Clear old caches, if present
RUN find . -regextype posix-egrep -regex '.*/__pycache__.*' -delete

# Set up Oracle Client
ARG INSTANT_CLIENT_ZIP
RUN python -m pip install .
RUN setup_oracle_client -v
# Have to hard-code oracle_lib_export as ENV can't use result of command
ENV LD_LIBRARY_PATH=/app/etlhelper/oracle_instantclient
