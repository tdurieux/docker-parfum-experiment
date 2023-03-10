FROM latera/homs_base:latest

USER root

RUN apt-get update && \
  apt-get install --no-install-recommends -y \
  libfontconfig1 \
  libfontconfig1-dev \
  libfreetype6 \
  libfreetype6-dev \
  libqt5webkit5-dev && rm -rf /var/lib/apt/lists/*;

RUN apt-get update && \
  apt-get install --no-install-recommends -y \
  fonts-liberation \
  gstreamer1.0-plugins-base \
  gstreamer1.0-tools \
  gstreamer1.0-x \
  libayatana-indicator7 \
  libasound2 \
  libgtk-3-0 \
  libnspr4 \
  libnss3 \
  libxss1 \
  libxtst6 \
  unzip \
  xdg-utils \
  zip && rm -rf /var/lib/apt/lists/*;

ARG CHROME_DEB_LINK

RUN wget -O google-chrome.deb $CHROME_DEB_LINK && \
  dpkg -i google-chrome.deb
RUN chrome_version=$(google-chrome --version | grep -oE '[0-9]{2,}' | head -1) && \
  chromedriver_version=$(wget -qO- https://chromedriver.storage.googleapis.com/LATEST_RELEASE_$chrome_version) && \
  wget https://chromedriver.storage.googleapis.com/$chromedriver_version/chromedriver_linux64.zip && \
  unzip chromedriver_linux64.zip chromedriver -d /usr/local/bin/ && \
  chmod +x /usr/local/bin/chromedriver

COPY --chown=homs ./run_tests.sh ./.rubocop.yml ./.rubocop_todo.yml /
COPY --chown=homs ./.rubocop.yml ./.rubocop_todo.yml ./jest.config.js /opt/homs/

USER homs
RUN yarn install && \
  bundle --with test --without oracle && yarn cache clean;

ENTRYPOINT ["/run_tests.sh"]
