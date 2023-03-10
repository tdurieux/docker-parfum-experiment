FROM python:2-slim

RUN apt-get update \
  # dependencies for building Python packages \
  && apt-get install --no-install-recommends -y build-essential \
  && apt-get install --no-install-recommends -y python-dev \
  && apt-get install --no-install-recommends -y wget \
  && apt-get install --no-install-recommends -y zip unzip && rm -rf /var/lib/apt/lists/*;

WORKDIR /usr/src/app

COPY requirements ./requirements
COPY ./docker/app/run.sh /run.sh
COPY ./docker/app/get_chrome_driver.py /usr/src/get_chrome_driver.py

RUN pip install --no-cache-dir -r requirements/requirements.txt -t lib/
RUN pip install --no-cache-dir -r requirements/local_requirements.txt

# Install App engine SDK
RUN wget https://storage.googleapis.com/appengine-sdks/featured/google_appengine_1.9.90.zip -nv -P /usr/src/
RUN unzip -q /usr/src/google_appengine_1.9.90.zip -d /usr/src/
ENV SDK_LOCATION="/usr/src/google_appengine"

# Install Google Chrome for running tests
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub -P /usr/src/ | apt-key add -
RUN sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
RUN apt-get -y update
RUN apt-get install --no-install-recommends -y google-chrome-stable && rm -rf /var/lib/apt/lists/*;

# Set display port to avoid crash
ENV DISPLAY=:99

COPY . .

# Install chromedriver
RUN python /usr/src/get_chrome_driver.py /usr/src/
RUN unzip -q /usr/src/chromedriver_linux64.zip -d /usr/local/bin/

ENTRYPOINT [ "/run.sh" ]
