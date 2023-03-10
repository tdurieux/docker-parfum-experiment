FROM python:3.7.7

# set appropriately if needed for your environment
ARG http_proxy
ARG https_proxy
ENV http_proxy $http_proxy
ENV https_proxy $https_proxy
ENV ALLOWED_HOST localhost

RUN apt-get update && apt-get -y upgrade
RUN apt-get -y --no-install-recommends install python-gdbm python-tk && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install binutils libproj-dev gdal-bin nodejs libnode-dev npm postgresql-client-common postgresql-client netcat && rm -rf /var/lib/apt/lists/*;
RUN npm install -g less && npm cache clean --force;
# RUN ln -s /usr/bin/nodejs /usr/bin/node

ADD . /usr/src/geoq/
WORKDIR /usr/src/geoq

RUN ls /usr/src/geoq
RUN pip install --no-cache-dir -r /usr/src/geoq/geoq/requirements.txt --proxy=$http_proxy

RUN dpkg -i ./geoq/tools/geographiclib_1.36-2_amd64.deb
RUN apt-get install -y -f

RUN mkdir -p /var/www/static/kml
RUN chmod 777 /var/www/static/kml

EXPOSE 8000

COPY ./docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]
