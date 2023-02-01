FROM ubuntu:20.04

# Install nginx (see http://nginx.org/en/linux_packages.html#Ubuntu)
RUN \
    apt-get update \
    && apt-get install --no-install-recommends -y curl gnupg2 ca-certificates lsb-release \
    && echo "deb http://nginx.org/packages/mainline/ubuntu `lsb_release -cs` nginx" | tee /etc/apt/sources.list.d/nginx.list \
    && curl -fsSL https://nginx.org/keys/nginx_signing.key | apt-key add - \
    && apt-get update \
    && apt-get install -y --no-install-recommends nginx \
    && apt-get install --no-install-recommends -y nginx-module-njs && rm -rf /var/lib/apt/lists/*;

# Install python3 and pip
RUN \
    apt-get update \
    && apt-get install --no-install-recommends -y python3.8 python3-pip \
    && ln -s /usr/bin/python3.8 /usr/bin/python && rm -rf /var/lib/apt/lists/*;
#    && ln -s /usr/bin/pip3 /usr/bin/pip

# Install lib required for psycopg2
RUN \
  apt-get update \
  && apt-get install --no-install-recommends -y libpq-dev && rm -rf /var/lib/apt/lists/*;

# Install gunicorn and uvicorn to run FastAPI optimized
RUN pip install --no-cache-dir "uvicorn[standard]" gunicorn faker

RUN mkdir /resources

COPY backend/ /resources/app
WORKDIR /resources/app/
RUN pip install --no-cache-dir .

COPY ./docker/server/start.sh /resources/start.sh
RUN chmod +x /resources/start.sh

COPY ./docker/entrypoint.sh /resources/entrypoint.sh
RUN chmod +x /resources/entrypoint.sh

COPY ./docker/server/gunicorn_conf.py /gunicorn_conf.py

COPY docker/nginx /etc/nginx
COPY webapp/build /resources/webapp

ENV PYTHONPATH=/resources/app \
    MODULE_NAME=insert_component_name_here.app \
    WEB_CONCURRENCY="1"

ENTRYPOINT ["/bin/bash"]
CMD ["/resources/entrypoint.sh"]
