FROM navitia/master


COPY navitia/source/sql/alembic /usr/share/navitia/ed/alembic
COPY /navitia/source/sql/requirements.txt /tmp/requirements.txt
RUN pip install --no-cache-dir -r /tmp/requirements.txt

COPY navitia/source/cities /usr/share/navitia/cities

COPY instances_configuration.sh /
COPY templates/* /templates/



CMD sh -x /instances_configuration.sh
