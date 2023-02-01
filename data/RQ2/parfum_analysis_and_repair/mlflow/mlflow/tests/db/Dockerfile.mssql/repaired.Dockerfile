FROM python:3.7

ARG DEPENDENCIES

# apt-get and system utilities
RUN apt-get update && apt-get install --no-install-recommends -y \
    curl apt-transport-https debconf-utils \
    && rm -rf /var/lib/apt/lists/*

# adding custom MS repository
RUN curl -f https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
RUN curl -f https://packages.microsoft.com/config/ubuntu/20.04/prod.list > /etc/apt/sources.list.d/mssql-release.list

# install SQL Server drivers and tools
RUN apt-get update && ACCEPT_EULA=Y apt-get --no-install-recommends install -y mssql-tools unixodbc-dev && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir pyodbc pytest pytest-cov
RUN echo "${DEPENDENCIES}" > /tmp/requriements.txt && pip install --no-cache-dir -r /tmp/requriements.txt
RUN pip list
