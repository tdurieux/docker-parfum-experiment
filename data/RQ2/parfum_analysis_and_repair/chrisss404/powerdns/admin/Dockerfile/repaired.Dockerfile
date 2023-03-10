FROM alpine:3.15 AS builder

ENV FLASK_APP=/build/powerdnsadmin/__init__.py

ARG ADMIN_VERSION="latest"

ARG BUILD_DEPENDENCIES="build-base \
    cargo \
    git \
    libffi-dev \
    libxml2-dev \
    mariadb-connector-c-dev \
    openldap-dev \
    python3-dev \
    xmlsec-dev \
    yarn"

# Get dependencies
RUN apk add --no-cache ${BUILD_DEPENDENCIES} py3-pip && \
    echo 'INPUT ( libldap.so )' > /usr/lib/libldap_r.so

# Download sources
RUN git clone -n https://github.com/ngoduykhanh/PowerDNS-Admin.git /build && \
    cd /build && \
    git checkout $([ "${ADMIN_VERSION}" = "latest" ] && echo "master" || echo "${ADMIN_VERSION}")

WORKDIR /build

# Get application dependencies
RUN sed -i 's/Flask==1.1.2/Flask==1.1.4\nmarkupsafe==2.0.1/g' requirements.txt && \
    sed -i 's/Jinja2==3.0.3/Jinja2==2.11.3/g' requirements.txt && \
    sed -i 's/itsdangerous==2.0.1/itsdangerous==1.1.0/g' requirements.txt && \
    sed -i 's/werkzeug==2.0.3/werkzeug==1.0.1/g' requirements.txt && \
    pip install --no-cache-dir -r requirements.txt

# Prepare assets
RUN yarn install --pure-lockfile --production && \
    yarn cache clean && \
    sed -i -r -e "s|'cssmin',\s?'cssrewrite'|'cssmin'|g" /build/powerdnsadmin/assets.py && \
    flask assets build && yarn cache clean;

RUN mv /build/powerdnsadmin/static /tmp/static && \
    mkdir /build/powerdnsadmin/static && \
    cp -r /tmp/static/generated /build/powerdnsadmin/static && \
    find /tmp/static/node_modules -name 'fonts' -exec cp -r {} /build/powerdnsadmin/static \; && \
    find /tmp/static/node_modules/icheck/skins/square -name '*.png' -exec cp {} /build/powerdnsadmin/static/generated \;

RUN { \
      echo "from flask_assets import Environment"; \
      echo "assets = Environment()"; \
      echo "assets.register('js_login', 'generated/login.js')"; \
      echo "assets.register('js_validation', 'generated/validation.js')"; \
      echo "assets.register('css_login', 'generated/login.css')"; \
      echo "assets.register('js_main', 'generated/main.js')"; \
      echo "assets.register('css_main', 'generated/main.css')"; \
    } > /build/powerdnsadmin/assets.py

# Move application
RUN mkdir -p /var/www/pdns-admin && \
    sed -i "/^SQLALCHEMY_DATABASE_URI/d" /build/configs/docker_config.py && \
    cp -r /build/configs/docker_config.py /build/migrations/ /build/powerdnsadmin/ /build/run.py /var/www/pdns-admin

COPY ./update_db_settings.py /var/www/pdns-admin/

# Cleanup
RUN pip install --no-cache-dir pip-autoremove && \
    pip-autoremove cssmin -y && \
    pip-autoremove jsmin -y && \
    pip-autoremove mysqlclient -y && \
    pip uninstall -y pip-autoremove pytest && \
    apk del ${BUILD_DEPENDENCIES}


# Build image
FROM alpine:3.15

ENV FLASK_APP=/var/www/pdns-admin/powerdnsadmin/__init__.py

RUN apk add --no-cache libldap postgresql-client py3-gunicorn py3-psycopg2 xmlsec && \
    addgroup -S pda && \
    adduser -S -D -G pda pda

COPY --from=builder /usr/bin/flask /usr/bin/
COPY --from=builder /usr/lib/python3.9/site-packages /usr/lib/python3.9/site-packages/
COPY --from=builder --chown=pda:pda /var/www/pdns-admin /var/www/pdns-admin/
COPY ./docker-entrypoint.sh /usr/bin/

WORKDIR /var/www/pdns-admin

EXPOSE 3031/tcp

HEALTHCHECK CMD ["wget", "--output-document=-", "--quiet", "--tries=1", "http://127.0.0.1:3031/"]
ENTRYPOINT ["docker-entrypoint.sh"]
CMD [ "gunicorn", "powerdnsadmin:create_app()", "--timeout", "120", "--workers", "4", \
        "--user", "pda", "--group", "pda", "--bind", "0.0.0.0:3031", "--log-level", "info"]
