FROM node:5


RUN apt-get update && \
apt-get install -y curl && \
apt-get clean && \
rm -rf /var/lib/apt/lists/*

# ffmpeg is hosted at deb-multimedia.org
RUN curl http://www.deb-multimedia.org/pool/main/d/deb-multimedia-keyring/deb-multimedia-keyring_2015.6.1_all.deb \
-o /tmp/deb-multimedia-keyring_2015.6.1_all.deb && \  
dpkg -i /tmp/deb-multimedia-keyring_2015.6.1_all.deb && \
rm /tmp/deb-multimedia-keyring_2015.6.1_all.deb && \
echo "deb http://www.deb-multimedia.org stretch main non-free" >> /etc/apt/sources.list &&\
echo "deb http://ftp.de.debian.org/debian jessie-backports main" >> /etc/apt/sources.list
         

RUN apt-get update && \
  apt-get install -y \
    openjdk-8-jre \
    xvfb \
    libgconf-2-4 \
    libexif12 \
    chromium \
    supervisor \
    netcat-traditional \
    curl &&  \
#    ffmpeg && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

RUN wget ftp.mozilla.org/pub/mozilla.org/firefox/releases/34.0.5/linux-x86_64/en-US/firefox-34.0.5.tar.bz2 --quiet && tar -xjvf firefox-34.0.5.tar.bz2 && mv firefox /opt/firefox && ln -sf /opt/firefox/firefox /usr/bin/firefox && rm firefox-34.0.5.tar.bz2

RUN npm install -g protractor@1.5.0

# Install Selenium and Chrome driver
RUN webdriver-manager update

# Add a non-privileged user for running Protrator
RUN adduser --home /project --uid 1000 \
  --disabled-login --disabled-password --gecos node node

# By default, tests in /data directory will be executed once and then the container
# will quit. When MANUAL envorinment variable is set when starting the container,
# tests will NOT be executed and Xvfb and Selenium will keep running.
ADD bin/run-protractor /usr/local/bin/run-protractor

# Container's entry point, executing supervisord in the foreground
CMD ["/usr/local/bin/run-protractor"]

# Protractor test project needs to be mounted at /project
VOLUME ["/project"]
