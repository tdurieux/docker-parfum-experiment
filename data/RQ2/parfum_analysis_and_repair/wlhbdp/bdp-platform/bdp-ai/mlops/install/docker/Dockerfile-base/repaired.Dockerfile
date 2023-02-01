FROM python:3.6-jessie

# Configure environment
ENV LANG=C.UTF-8 \
    LC_ALL=C.UTF-8

RUN apt-get update -y && \
    apt-get install --no-install-recommends -y apt-transport-https apt-utils build-essential libssl-dev \
    libglib2.0-0 libnss3 libgconf-2-4 libfontconfig1 \
    vim less postgresql-client redis-tools \
    libffi-dev python3-dev libsasl2-dev libldap2-dev libxi-dev && \
    curl -f -sL https://deb.nodesource.com/setup_10.x | bash - && rm -rf /var/lib/apt/lists/*;


RUN apt-get install --no-install-recommends -y nodejs && \
    apt-get install -y --force-yes --no-install-recommends ttf-wqy-microhei ttf-wqy-zenhei xfonts-wqy && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir clickhouse-sqlalchemy pysnooper pymysql gevent mysqlclient flower infi.clickhouse_orm opencv-python numpy sqlalchemy_utils

WORKDIR /home/myapp

COPY install/docker/requirements.txt .
COPY install/docker/requirements-dev.txt .

RUN pip install --no-cache-dir --upgrade setuptools pip && \
    pip install --no-cache-dir -r requirements.txt -r && \
    rm -rf /root/.cache/pip && \
    CHROMEDRIVER_VERSION=$( curl -f -sS chromedriver.storage.googleapis.com/LATEST_RELEASE) && \
    mkdir -p /opt/chromedriver-$CHROMEDRIVER_VERSION && \
    curl -f -sS -o /tmp/chromedriver_linux64.zip https://chromedriver.storage.googleapis.com/$CHROMEDRIVER_VERSION/chromedriver_linux64.zip && \
    unzip -qq /tmp/chromedriver_linux64.zip -d /opt/chromedriver-$CHROMEDRIVER_VERSION && \
    rm /tmp/chromedriver_linux64.zip && \
    chmod +x /opt/chromedriver-$CHROMEDRIVER_VERSION/chromedriver && \
    ln -fs /opt/chromedriver-$CHROMEDRIVER_VERSION/chromedriver /usr/local/bin/chromedriver && \
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
    dpkg -i google-chrome-stable_current_amd64.deb; apt-get -fy install && \
    rm google-chrome-stable_current_amd64.deb

USER root

EXPOSE 80

