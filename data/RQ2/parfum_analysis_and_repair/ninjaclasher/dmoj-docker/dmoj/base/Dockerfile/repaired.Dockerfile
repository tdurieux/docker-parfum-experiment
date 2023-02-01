FROM python:3.8-slim-buster

RUN apt-get update && \
    apt-get install --no-install-recommends -y \
        git gcc g++ make curl gettext wget \
        libxml2-dev libxslt1-dev zlib1g-dev \
        mariadb-client libmariadbclient-dev \
        libjpeg-dev debconf-utils && \
    curl -f -sL https://deb.nodesource.com/setup_12.x | bash - && \
    apt-get install --no-install-recommends -y nodejs && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

RUN npm install -g sass postcss-cli postcss autoprefixer && npm cache clean --force;
RUN pip3 install --no-cache-dir \
        pymysql mysqlclient websocket-client uwsgi django-redis redis

RUN apt-get update && \
    apt-get install --no-install-recommends -y unzip xvfb libxi6 libgconf-2-4 && \
    curl -f -sS -o - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add && \
    echo "deb [arch=amd64]  http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list && \
    apt-get -y update && \
    apt-get -y --no-install-recommends install google-chrome-stable && \
    wget https://chromedriver.storage.googleapis.com/$( curl -f -s https://chromedriver.storage.googleapis.com/LATEST_RELEASE)/chromedriver_linux64.zip && \
    unzip chromedriver_linux64.zip && \
    mv chromedriver /usr/bin/chromedriver && \
    chmod +x /usr/bin/chromedriver && \
    rm chromedriver_linux64.zip && \
    rm -rf /var/lib/apt/lists/* && \
    pip3 install --no-cache-dir selenium

COPY repo/requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt
