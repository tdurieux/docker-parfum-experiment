FROM navitia/master

COPY navitia/source/sql/alembic /usr/share/navitia/ed/alembic
COPY navitia/source/sql/requirements.txt /tmp/requirements.txt
COPY navitia/source/cities /usr/share/navitia/cities
COPY templates/* /templates/

RUN apt-get update \
    && apt install --no-install-recommends -y python python-pip git libpq-dev postgresql-client gettext-base \
    && apt-get clean && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir -r /tmp/requirements.txt

COPY instances_configuration.sh /
RUN chmod +x /instances_configuration.sh

ENTRYPOINT ["/bin/bash","/instances_configuration.sh"]
