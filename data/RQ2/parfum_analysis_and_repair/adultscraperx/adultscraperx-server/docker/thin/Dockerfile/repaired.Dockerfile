FROM python:3.7

# install google chrome and drive
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list' \
    && apt-get -y update \
    && apt-get install --no-install-recommends -y google-chrome-stable git \
    && apt-get install --no-install-recommends -yqq unzip \
    && wget -O /tmp/chromedriver.zip https://chromedriver.storage.googleapis.com/$( curl -f -sS chromedriver.storage.googleapis.com/LATEST_RELEASE)/chromedriver_linux64.zip \
    && unzip /tmp/chromedriver.zip chromedriver -d /usr/local/bin/ \

# set display p && rm -rf /var/lib/apt/lists/*;

# install python packegs
RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir selenium \
    && pip install --no-cache-dir lxml \
    && pip install --no-cache-dir image \
    && pip3 install --no-cache-dir pillow \
    && pip install --no-cache-dir requests \
    && pip install --no-cache-dir pymongo \
    && pip install --no-cache-dir flask \
    && pip install --no-cache-dir googletrans

RUN useradd -ms /bin/bash adultScraperX
WORKDIR  /home/adultScraperX
RUN cd /home/adultScraperX \
    && git clone --depth=1 https://github.com/AdultScraperX/AdultScraperX-server.git AdultScraperX-server/ \
    && mv AdultScraperX-server/docker/thin/config.py AdultScraperX-server/config/config.py
USER adultScraperX
CMD python3 AdultScraperX-server/main.py
