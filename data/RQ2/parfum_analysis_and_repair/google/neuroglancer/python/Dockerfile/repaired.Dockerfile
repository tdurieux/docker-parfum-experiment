FROM python:3.8

# https://hub.docker.com/r/joyzoursky/python-chromedriver/dockerfile

# install google chrome
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
  sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list' && \
  apt-get -y update && \
  apt-get install --no-install-recommends -y google-chrome-stable unzip && rm -rf /var/lib/apt/lists/*;

# install chromedriver
RUN wget -O /tmp/chromedriver.zip https://chromedriver.storage.googleapis.com/$( curl -f -sS chromedriver.storage.googleapis.com/LATEST_RELEASE)/chromedriver_linux64.zip && \
  unzip /tmp/chromedriver.zip chromedriver -d /usr/local/bin/ && \
  rm -f /tmp/chromedriver.zip

RUN pip install --no-cache-dir numpy Pillow requests tornado six google-apitools selenium

# Install Neuroglancer
ADD . python
RUN find python && pip install --no-cache-dir ./python

# set display port to avoid crash
ENV DISPLAY=:99
