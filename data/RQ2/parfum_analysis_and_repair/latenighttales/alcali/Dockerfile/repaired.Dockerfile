FROM python:3.7-slim-stretch

MAINTAINER Matt Melquiond

# Used in travis
ARG USER_ID=1000

# Upgrade System and Install dependencies
RUN apt-get update \
  && seq 1 8 | xargs -I{} mkdir -p /usr/share/man/man{} \
  && apt-get install -y --no-install-recommends -o DPkg::Options::=--force-confold netcat libmariadbclient-dev libpq-dev build-essential libldap2-dev libsasl2-dev ldap-utils git && rm -rf /var/lib/apt/lists/*;

# Upgrade pip
RUN pip install --no-cache-dir --upgrade pip

# Create unprivileged user
RUN useradd -u ${USER_ID} -ms /bin/bash -d /opt/alcali alcali

# Set default user
USER alcali

# Add env var and fix path
ENV PYTHONUNBUFFERED=1 PATH="/opt/alcali/.local/bin:${PATH}"

# Copy project
COPY --chown=alcali . /opt/alcali/code

# Set work directory
WORKDIR /opt/alcali/code

# Install dependencies
RUN pip install --no-cache-dir --user -U setuptools

# Install project
RUN pip install --no-cache-dir --user .[ldap,social] mysqlclient psycopg2

EXPOSE 8000

ENTRYPOINT ["/opt/alcali/code/docker/utils/entrypoint.sh"]
