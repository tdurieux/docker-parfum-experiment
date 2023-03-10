# Stage 1: Frontend
# Remove this part if it is conflicting with the frontend you are currently testing
FROM node:lts-alpine3.14 as frontend-build

WORKDIR /
# copy react source code
COPY frontend/ .
# copy version file as an env file
COPY docker/.version .env.local
# install and build
RUN npm install npm@latest -g
RUN npm install

RUN PUBLIC_URL=/static/reactapp/ npm run build

# Stage 2: Backend
FROM python:3.9.9-buster

COPY --from=frontend-build /build /var/www/reactapp

ENV PYTHONUNBUFFERED 1
ENV DJANGO_SETTINGS_MODULE intel_owl.settings
ENV PYTHONPATH /opt/deploy/intel_owl
ENV LOG_PATH /var/log/intel_owl
ENV ELASTICSEARCH_DSL_VERSION 7.2.0
ENV watch_logs_cmd "watch -n1 tail -n10 /var/log/intel_owl/django/api_app.log"

ARG REPO_DOWNLOADER_ENABLED=true
ARG WATCHMAN=false

RUN mkdir -p ${LOG_PATH} \
    ${LOG_PATH}/django \
    ${LOG_PATH}/uwsgi \
    /opt/deploy/files_required /opt/deploy/yara /opt/deploy/configuration

# install required packages. some notes about:
# python3-psycopg2 is required to use PostgresSQL with Django
# osslsigncode is required to run the signature verification analyzer
# apache2-utils is required to execute htpasswd
RUN apt-get update \
    && apt-get install -y --no-install-recommends apt-utils libsasl2-dev libssl-dev \
    vim libldap2-dev python-dev libfuzzy-dev net-tools python3-psycopg2 git osslsigncode apache2-utils \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
RUN pip3 install --upgrade pip

COPY requirements/project-requirements.txt $PYTHONPATH/project-requirements.txt
WORKDIR $PYTHONPATH

RUN pip3 install --no-cache-dir --compile -r project-requirements.txt
# install elasticsearch-dsl's appropriate version as specified by user
RUN pip3 install --no-cache-dir django-elasticsearch-dsl==${ELASTICSEARCH_DSL_VERSION}

COPY requirements/certego-requirements.txt $PYTHONPATH/certego-requirements.txt
RUN pip3 install --no-cache-dir --compile -r certego-requirements.txt

COPY . $PYTHONPATH

RUN touch ${LOG_PATH}/django/api_app.log ${LOG_PATH}/django/api_app_errors.log \
    && touch ${LOG_PATH}/django/celery.log ${LOG_PATH}/django/celery_errors.log \
    && touch ${LOG_PATH}/django/django_auth_ldap.log \
    && chown -R www-data:www-data ${LOG_PATH} /opt/deploy/ \
    # this is cause stringstifer creates this directory during the build and cause celery to crash
    && rm -rf /root/.local

RUN docker/scripts/watchman_install.sh

# download yara rules and quark engine rules
RUN api_app/analyzers_manager/repo_downloader.sh

# this is because botocore points to legacy endpoints
# more info: https://stackoverflow.com/questions/41062055/celery-4-0-0-amazon-sqs-credential-should-be-scoped-to-a-valid-region-not
RUN sed -i "s/{region}.queue/sqs.{region}/g" "$(find / -name endpoints.json 2>/dev/null | head -n 1)"

# quarkengine calls
# HOME_DIR = f"{Path.home()}/.quark-engine/"
# Path(HOME_DIR).mkdir(parents=True, exist_ok=True)
# so we have to set the home env variable to allow to reate its directory
ENV HOME ${PYTHONPATH}
