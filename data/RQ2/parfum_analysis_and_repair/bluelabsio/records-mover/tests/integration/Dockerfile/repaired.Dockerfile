FROM python:3.6

# database connection scripts, psql CLI client for postgres and
# Redshift, Vertica vsql client, MySQL client and misc shell tools for
# integration tests

RUN apt-get update && apt-get install --no-install-recommends -y netcat jq postgresql-client curl default-mysql-client && rm -rf /var/lib/apt/lists/*;

# google-cloud-sdk for dbcli and bigquery in integration tests
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && curl -f https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg  add - && apt-get update -y && apt-get install --no-install-recommends google-cloud-sdk -y && rm -rf /var/lib/apt/lists/*;

RUN ln -s /bin/zcat /bin/gzcat

#
# Install Vertica client for mover CLI integration test
#

RUN cd / && \
    wget https://www.vertica.com/client_drivers/9.2.x/9.2.0-0/vertica-client-9.2.0-0.x86_64.tar.gz && \
    tar -xzvf vertica-client-9.2.0-0.x86_64.tar.gz && \
    rm -fr /vertica-client-9.2.0-0.x86_64.tar.gz /opt/vertica/Python/ /opt/vertica/java /opt/vertica/bin/vsql32
ENV PATH $PATH:/opt/vertica/bin

WORKDIR /usr/src/app

COPY README.md requirements.txt setup.py /usr/src/app/

RUN mkdir /usr/src/app/records_mover && rm -rf /usr/src/app/records_mover

COPY records_mover/version.py /usr/src/app/records_mover

RUN pip3 install --no-cache-dir -r requirements.txt -e '/usr/src/app[movercli]'

COPY . /usr/src/app

#
# Allow us to get coverage and quality metrics back out
#
VOLUME /usr/src/app
