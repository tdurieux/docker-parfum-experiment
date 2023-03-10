# This Dockerfile builds the image used for CI/testing.
FROM ubuntu:16.04

# Set PATH
ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/go/bin:/opt/mssql-tools/bin

# Install bootstrap-y tools
RUN apt-get update \
    && apt-get install --no-install-recommends -y apt-transport-https software-properties-common python3-software-properties \
    && apt-add-repository ppa:git-core/ppa \
    && apt-get update \
    && apt-get install --no-install-recommends -y curl git make locales && rm -rf /var/lib/apt/lists/*;

# Set up locales for sqlcmd (otherwise it breaks)
RUN locale-gen en_US.UTF-8 \
    && echo "LC_ALL=en_US.UTF-8" >> /etc/default/locale \
    && echo "LANG=en_US.UTF-8" >> /etc/default/locale

# Install database clients
# MySQL 8.0 is still in development, so we're using 5.7 which is already
# available in Ubuntu 16.04
RUN curl -f https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - \
    && echo 'deb http://apt.postgresql.org/pub/repos/apt/ xenial-pgdg main' > /etc/apt/sources.list.d/psql.list \
    && curl -f https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
    && curl -f https://packages.microsoft.com/config/ubuntu/16.04/prod.list > /etc/apt/sources.list.d/msprod.list \
    && apt-get update \
    && env ACCEPT_EULA=Y apt-get install -y git postgresql-client-9.6 mysql-client-5.7 mssql-tools unixodbc-dev

# Install Go + Go based tooling
ENV GOLANG_VERSION 1.10
RUN curl -f -o go.tar.gz "https://storage.googleapis.com/golang/go${GOLANG_VERSION}.linux-amd64.tar.gz" \
    && rm -rf /usr/local/go \
    && tar -C /usr/local -xzf go.tar.gz \
    && go get -u -v github.com/jstemmer/go-junit-report \
    && mv /root/go/bin/go-junit-report /usr/bin/go-junit-report && rm go.tar.gz
