FROM krallin/ubuntu-tini:16.04

LABEL name="Qinling" \
      description="Function Engine for OpenStack" \
      maintainers="Gaëtan Trellu <gaetan.trellu@incloudus.com>"

RUN apt-get -qq update && \
    apt-get install -y  \
      libffi-dev \
      libpq-dev \
      libssl-dev \
      libxml2-dev \
      libxslt1-dev \
      libyaml-dev \
      libmysqlclient-dev \
      python \
      python-dev \
      crudini \
      curl \
      git \
      gcc \
      libuv1 \
      libuv1-dev && \
      curl -f -o /tmp/get-pip.py https://bootstrap.pypa.io/3.2/get-pip.py && \
      python /tmp/get-pip.py && rm /tmp/get-pip.py && \
      pip install --upgrade pip

RUN pip install pymysql psycopg2 py_mini_racer

ENV QINLING_DIR="/opt/stack/qinling" \
    TMP_CONSTRAINTS="/tmp/upper-constraints.txt" \
    CONFIG_FILE="/etc/qinling/qinling.conf" \
    INI_SET="crudini --set /etc/qinling/qinling.conf" \
    MESSAGE_BROKER_URL="rabbit://guest:guest@rabbitmq:5672/" \
    DATABASE_URL="sqlite:///qinling.db" \
    UPGRADE_DB="false" \
    DEBIAN_FRONTEND="noninteractive" \
    QINLING_SERVER="all" \
    LOG_DEBUG="false" \
    AUTH_ENABLE="false"

# We install dependencies separatly for a caching purpose
COPY requirements.txt "${QINLING_DIR}/"
RUN curl -o "${TMP_CONSTRAINTS}" \
    http://opendev.org/openstack/requirements/raw/branch/master/upper-constraints.txt && \
    sed -i "/^qinling.*/d" "${TMP_CONSTRAINTS}" && \
    pip install -r "${QINLING_DIR}/requirements.txt"

COPY . ${QINLING_DIR}

RUN pip install -e "${QINLING_DIR}" && \
    mkdir /etc/qinling && \
    rm -rf /var/lib/apt/lists/* && \
    find ${QINLING_DIR} -name "*.sh" -exec chmod +x {} \;

WORKDIR "${QINLING_DIR}"
EXPOSE 7070
CMD "${QINLING_DIR}/tools/docker/start.sh"
