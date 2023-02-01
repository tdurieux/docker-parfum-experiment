FROM python:3.5

ENV PYTHONUNBUFFERED 1

#install geos
RUN mkdir geos \
    && wget -q http://download.osgeo.org/geos/geos-3.4.2.tar.bz2 -O - | tar xfj - -C geos --strip-components 1 \
    && cd geos && ./configure && make && make install && cd - \
    && rm -r geos

RUN mkdir -p /opt/maxmind/

RUN cd /tmp/ \
    && wget -q -O GeoLite2-City.mmdb.gz "http://geolite.maxmind.com/download/geoip/database/GeoLite2-City.mmdb.gz" \
    && gunzip GeoLite2-City.mmdb.gz \
    && find . -type f -name "*.mmdb" | xargs -I dbfile mv dbfile /opt/maxmind/

# Requirements have to be pulled and installed here, otherwise caching won't work
COPY ./requirements /requirements
RUN pip install --no-cache-dir -r /requirements/local.txt

RUN apt-get update && \
    apt-get install -y gettext && \
    apt-get install -y libgdal-dev && \
    apt-get install -y postgresql-client && \
    apt-get clean && rm -rf /var/cache/apt/* && rm -rf /var/lib/apt/lists/* && rm -rf /tmp/*

COPY ./compose/django/entrypoint.sh /entrypoint.sh
RUN sed -i 's/\r//' /entrypoint.sh
RUN chmod +x /entrypoint.sh

WORKDIR /app

ENTRYPOINT ["/entrypoint.sh"]
