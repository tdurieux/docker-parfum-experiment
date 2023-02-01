FROM mytardis/mytardis-run

USER root

RUN apt-get update && apt-get install --no-install-recommends \
    -qy \
    unzip \
    openjdk-8-jre-headless \
    xvfb \
    libxi6 \
    libgconf-2-4 \
    wget \
    slapd ldap-utils \
    libxss1 && rm -rf /var/lib/apt/lists/*;

RUN curl -f -sS -o - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add && \
    echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list && \
    apt-get update && apt-get install --no-install-recommends -qy google-chrome-stable && rm -rf /var/lib/apt/lists/*;

RUN export CHROME_DRIVER_VERSION=$( curl -f -sS https://chromedriver.storage.googleapis.com/LATEST_RELEASE) && \
    wget -N https://chromedriver.storage.googleapis.com/${CHROME_DRIVER_VERSION}/chromedriver_linux64.zip -P ~/ && \
    unzip ~/chromedriver_linux64.zip -d ~/ && \
    mv -f ~/chromedriver /usr/local/bin/chromedriver && \
    chmod 0755 /usr/local/bin/chromedriver

ENV PATH="/usr/local/bin:${PATH}"

RUN chown -R webapp:webapp /home/webapp
USER webapp
RUN . /appenv/bin/activate; \
    pip install --no-cache-dir --no-index -f /wheelhouse -r requirements-postgres.txt
RUN . /appenv/bin/activate; \
    pip install --no-cache-dir --no-index -f /wheelhouse -r requirements-mysql.txt
RUN . /appenv/bin/activate; \
    pip install --no-cache-dir coveralls codacy-coverage
VOLUME /home/webapp/tardis
VOLUME /home/webapp/docs

RUN mkdir -p var/store

CMD bash -c '. /appenv/bin/activate; source ./test.sh'
