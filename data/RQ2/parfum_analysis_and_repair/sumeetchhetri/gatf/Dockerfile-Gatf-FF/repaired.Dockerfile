FROM sumeetchhetri/gatf-jar:latest

FROM ubuntu:20.04

ENV D_JAVA_HOME /usr/lib/jvm/java-11-openjdk-amd64/
ENV D_FF_DRIVER /usr/bin/geckodriver
ENV D_GATF_JAR /gatf-alldep.jar
ENV SCREEN_WIDTH 1360
ENV SCREEN_HEIGHT 1020
ENV SCREEN_DEPTH 24
ENV SCREEN_DPI 96

ARG DEBIAN_FRONTEND=noninteractive

RUN apt update -yqq && apt install -yqq --no-install-recommends zlib1g-dev ca-certificates curl openjdk-11-jdk openjdk-11-jre libluajit-5.1-dev luajit libssl-dev git wget unzip net-tools build-essential software-properties-common xvfb fluxbox wmctrl gnupg && rm -rf /var/lib/apt/lists/*

ARG NODE_VERSION=16.13.1
ARG NODE_PACKAGE=node-v$NODE_VERSION-linux-x64
ARG NODE_HOME=/opt/$NODE_PACKAGE
ENV NODE_PATH $NODE_HOME/lib/node_modules
ENV PATH $NODE_HOME/bin:$PATH
RUN curl -f -L https://nodejs.org/dist/v$NODE_VERSION/$NODE_PACKAGE.tar.gz | tar -xzC /opt/
RUN npm install -g autocannon && npm cache clean --force;

#=========
# Firefox
#=========
ARG FIREFOX_VERSION=latest
RUN FIREFOX_DOWNLOAD_URL=$(if [ $FIREFOX_VERSION = "latest" ] || [ $FIREFOX_VERSION = "nightly-latest" ] || [ $FIREFOX_VERSION = "devedition-latest" ] || [ $FIREFOX_VERSION = "esr-latest" ]; then echo "https://download.mozilla.org/?product=firefox-$FIREFOX_VERSION-ssl&os=linux64&lang=en-US"; else echo "https://download-installer.cdn.mozilla.net/pub/firefox/releases/$FIREFOX_VERSION/linux-x86_64/en-US/firefox-$FIREFOX_VERSION.tar.bz2"; fi) \
  && apt-get update -qqy \
  && apt-get -qqy --no-install-recommends install firefox libavcodec-extra \
  && rm -rf /var/lib/apt/lists/* /var/cache/apt/* \
  && wget --no-verbose -O /tmp/firefox.tar.bz2 $FIREFOX_DOWNLOAD_URL \
  && apt-get -y purge firefox \
  && rm -rf /opt/firefox \
  && tar -C /opt -xjf /tmp/firefox.tar.bz2 \
  && rm /tmp/firefox.tar.bz2 \
  && mv /opt/firefox /opt/firefox-$FIREFOX_VERSION \
  && ln -fs /opt/firefox-$FIREFOX_VERSION/firefox /usr/bin/firefox

#============
# GeckoDriver
#============
ARG GECKODRIVER_VERSION=latest
RUN GK_VERSION=$(if [ ${GECKODRIVER_VERSION:-latest} = "latest" ]; then echo "0.27.0"; else echo $GECKODRIVER_VERSION; fi) \
  && echo "Using GeckoDriver version: "$GK_VERSION \
  && wget --no-verbose -O /tmp/geckodriver.tar.gz https://github.com/mozilla/geckodriver/releases/download/v$GK_VERSION/geckodriver-v$GK_VERSION-linux64.tar.gz \
  && rm -rf /opt/geckodriver \
  && tar -C /opt -zxf /tmp/geckodriver.tar.gz \
  && rm /tmp/geckodriver.tar.gz \
  && mv /opt/geckodriver /opt/geckodriver-$GK_VERSION \
  && chmod 755 /opt/geckodriver-$GK_VERSION \
  && ln -fs /opt/geckodriver-$GK_VERSION /usr/bin/geckodriver

#============================================
# Add normal user and group with passwordless sudo
#============================================
RUN groupadd seluser \
         --gid 1201 \
  && useradd seluser \
         --create-home \
         --gid 1201 \
         --shell /bin/bash \
         --uid 1200 \
  && usermod -a -G sudo seluser \
  && echo 'ALL ALL = (ALL) NOPASSWD: ALL' >> /etc/sudoers \
  && echo 'seluser:secret' | chpasswd

COPY --from=0 /usr/local/bin/wrk /usr/local/bin/
COPY --from=0 /usr/local/bin/wrk2 /usr/local/bin/
COPY --from=0 /usr/local/bin/vegeta /usr/local/bin/
COPY --from=0 /gatf-alldep.jar /
COPY artifacts/run-gatf.sh artifacts/run-ff.sh /
COPY artifacts/sample1.* artifacts/jpg* artifacts/png* /home/seluser/
RUN chmod +x /run-gatf.sh /run-ff.sh

WORKDIR /workdir

RUN chown -Rf seluser:seluser /home/seluser/* /run-gatf.sh /run-ff.sh
RUN mv /run-ff.sh /run.sh

USER seluser

EXPOSE 9080

WORKDIR /workdir

ENTRYPOINT ["/run.sh"]
CMD [ "-configtool", "9080", "0.0.0.0", "/workdir" ]
