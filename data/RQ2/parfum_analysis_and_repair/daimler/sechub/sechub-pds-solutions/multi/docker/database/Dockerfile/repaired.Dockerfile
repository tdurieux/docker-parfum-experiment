# SPDX-License-Identifier: MIT

FROM ubuntu:20.04

ARG POSTGRES_CONFIG_FOLDER="/etc/postgresql/12/main/"

# Install PostgreSQL
RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get -qq update && \
    apt-get -qq --assume-yes upgrade && \
    apt-get -qq -y --no-install-recommends --assume-yes install postgresql postgresql-client && \
    apt-get -qq --assume-yes clean && rm -rf /var/lib/apt/lists/*;

# PostgreSQL configuration files
COPY pg_hba.conf  "$POSTGRES_CONFIG_FOLDER/pg_hba.conf"
COPY postgresql.conf "$POSTGRES_CONFIG_FOLDER/postgresql.conf"

# Copy run script into container
COPY run.sh /run.sh
RUN chmod +x /run.sh

# The postgres user was crated by the postgresql installation
USER postgres

CMD ["/run.sh"]