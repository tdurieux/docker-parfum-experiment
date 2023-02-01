ARG PYTHON_VERSION=3.7

FROM python:${PYTHON_VERSION}-slim-stretch

LABEL maintainer="houdinisparks@gmail.com" \
      description="Base image for python-<version> regression libraries to be used with oracle instantclient"

ENV TZ="Asia/Singapore"

WORKDIR /robot
COPY ./version-info /usr/bin

# ---------------------------------
# install misc tools --------------
# ---------------------------------

RUN apt-get update && apt-get -y --no-install-recommends install \
    wget gnupg2 curl unzip && rm -rf /var/lib/apt/lists/*;

# ----------------------------------------------------------
# install google chrome + google chrome driver
# ----------------------------------------------------------

ADD utils/headless-chrome /usr/bin/headless-chrome
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list \
    && apt-get update \
    && apt-get -y --no-install-recommends install apt-transport-https ca-certificates libxi6 libgconf-2-4 \
    && apt-get -y --no-install-recommends install google-chrome-stable && rm -rf /var/lib/apt/lists/*;

RUN chmod a+x /usr/bin/headless-chrome && \
    mv /opt/google/chrome/google-chrome /opt/google/chrome/google-chrome-browser \
    && rm /usr/bin/google-chrome-stable \
    && rm /usr/bin/google-chrome \
    && ln -s /opt/google/chrome/google-chrome-browser /usr/bin/chrome \
    && ln -s /usr/bin/headless-chrome /usr/bin/google-chrome

RUN CHROME_VERSION=$(chrome --version | cut -d. -f-3) \
    && CHROMEDRIVER_VERSION=$( curl -f https://chromedriver.storage.googleapis.com/LATEST_RELEASE_${CHROME_VERSION##* }) \
    && curl -f -SLO "https://chromedriver.storage.googleapis.com/${CHROMEDRIVER_VERSION}/chromedriver_linux64.zip" \
    && unzip "chromedriver_linux64.zip" -d /usr/local/bin \
    && rm "chromedriver_linux64.zip"

# -----------------------------
# install oracle
# -----------------------------
ARG ORACLE_VERSION=12.2.0.1.0
ENV ORACLE_VERSION=${ORACLE_VERSION}

 #TODO: make instantclient_12_2 a variable based on ORACLE_VERSION
ENV LD_LIBRARY_PATH=/opt/oracle/instantclient_12_2 \
    LD_RUN_PATH=$LD_LIBRARY_PATH

COPY instantclient/${ORACLE_VERSION}/* /tmp/

RUN set -x && \
    apt-get update && apt-get install --no-install-recommends -y \
    unzip build-essential libssl-dev libffi-dev lib32ncurses5-dev libaio1 && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /opt/oracle && \
    unzip "/tmp/instantclient*.zip" -d /opt/oracle && \
    ln -s "$LD_LIBRARY_PATH/libclntsh.so.12.2" $LD_LIBRARY_PATH/libclntsh.so
    # ln -s "$LD_LIBRARY_PATH/libclntsh.so.$(echo $ORACLE_VERSION | cut -d. -f-2)" $LD_LIBRARY_PATH/libclntsh.so

# -----------------------------
# check versions
# -----------------------------
RUN chrome --version
