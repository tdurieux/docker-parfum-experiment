FROM node:16 as frontend

FROM --platform=linux/amd64 python:3.9.13-slim-buster as backend

ARG SKIP_MSSQL_INSTALLATION

# Install auxiliary software
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    git \
    make \
    ipython \
    vim \
    curl \
    g++ \
    gnupg \
    gcc \
    python3-wheel \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*


RUN echo "Building fidesops celery worker"
RUN echo "ENVIRONMENT VAR:  SKIP_MSSQL_INSTALLATION $SKIP_MSSQL_INSTALLATION"

# SQL Server (MS SQL)
# https://docs.microsoft.com/en-us/sql/connect/odbc/linux-mac/installing-the-microsoft-odbc-driver-for-sql-server?view=sql-server-ver15
RUN if [ "$SKIP_MSSQL_INSTALLATION" != "true" ] ; then \
 apt-get install -y --no-install-recommends apt-transport-https; rm -rf /var/lib/apt/lists/*; fi
RUN if [ "$SKIP_MSSQL_INSTALLATION" != "true" ] ; then \
 curl -f https://packages.microsoft.com/keys/microsoft.asc | apt-key add -; fi
RUN if [ "$SKIP_MSSQL_INSTALLATION" != "true" ] ; then \
 curl -f https://packages.microsoft.com/config/debian/10/prod.list | tee /etc/apt/sources.list.d/msprod.list; fi
RUN if [ "$SKIP_MSSQL_INSTALLATION" != "true" ] ; then apt-get update ; fi
ENV ACCEPT_EULA=y DEBIAN_FRONTEND=noninteractive
RUN if [ "$SKIP_MSSQL_INSTALLATION" != "true" ] ; then \
 apt-get -y --no-install-recommends install \
    unixodbc-dev \
    msodbcsql17 \
    mssql-tools; rm -rf /var/lib/apt/lists/*; fi

# Update pip and install requirements
COPY requirements.txt dev-requirements.txt mssql-requirements.txt ./
RUN pip install --no-cache-dir -U pip \
    && pip --no-cache-dir install -r requirements.txt -r dev-requirements.txt \
    && if [ "$SKIP_MSSQL_INSTALLATION" != "true" ] ; then pip --no-cache-dir install -r mssql-requirements.txt ; fi


# Copy in the application files and install it locally
COPY . /fidesops
WORKDIR /fidesops
RUN pip install --no-cache-dir -e .

# Enable detection of running within Docker
ENV RUNNING_IN_DOCKER=true

CMD [ "fidesops", "worker" ]
