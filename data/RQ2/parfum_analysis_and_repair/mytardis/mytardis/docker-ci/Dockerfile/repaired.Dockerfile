FROM python:3.6

RUN curl -f -sS -o - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add && \
    echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list && \
    apt-get update && apt-get install --no-install-recommends -qy google-chrome-stable && rm -rf /var/lib/apt/lists/*;

RUN export CHROME_DRIVER_VERSION=$( curl -f -sS https://chromedriver.storage.googleapis.com/LATEST_RELEASE) && \
    wget -N https://chromedriver.storage.googleapis.com/${CHROME_DRIVER_VERSION}/chromedriver_linux64.zip -P ~/ && \
    unzip ~/chromedriver_linux64.zip -d ~/ && \
    mv -f ~/chromedriver /usr/local/bin/chromedriver && \
    chmod 0755 /usr/local/bin/chromedriver

RUN apt-get update && apt-get install --no-install-recommends -qy \
    libssl-dev \
    libsasl2-dev \
    libldap2-dev \
    libxi6 \
    libxss1 && rm -rf /var/lib/apt/lists/*;

WORKDIR /app
COPY . /app

RUN pip3 install --no-cache-dir -r requirements.txt
RUN pip3 install --no-cache-dir -r requirements-postgres.txt
RUN pip3 install --no-cache-dir -r requirements-mysql.txt

RUN mkdir -p var/store

CMD /app/test.sh
