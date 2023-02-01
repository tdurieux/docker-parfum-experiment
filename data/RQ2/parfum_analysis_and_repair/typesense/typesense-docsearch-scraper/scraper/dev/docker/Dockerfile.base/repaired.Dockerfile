FROM ubuntu:18.04
LABEL maintainer="contact@typesense.org"

WORKDIR /root

# Install selenium
ENV LC_ALL C
ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true

RUN useradd -d /home/seleuser -m seleuser
RUN chown -R seleuser /home/seleuser
RUN chgrp -R seleuser /home/seleuser

RUN apt-get update -y && apt-get install --no-install-recommends -yq \
    software-properties-common \
    python3.7 && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository -y ppa:openjdk-r/ppa
RUN apt-get update -y && apt-get install --no-install-recommends -yq \
    curl \
    wget \
    sudo \
    gnupg \
    && curl -f -sL https://deb.nodesource.com/setup_8.x | sudo bash - && rm -rf /var/lib/apt/lists/*;
RUN apt-get update -y && apt-get install --no-install-recommends -yq \
    nodejs -yq && rm -rf /var/lib/apt/lists/*;
RUN apt-get update -y && apt-get install --no-install-recommends -yq \
  unzip \
  xvfb \
  libxi6 \
  libgconf-2-4 \
  default-jdk && rm -rf /var/lib/apt/lists/*;

# https://www.ubuntuupdates.org/package/google_chrome/stable/main/base/google-chrome-stable for references around the latest versions
RUN curl -f -sS -o - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add
RUN echo "deb [arch=amd64]  http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list
RUN apt-get update -y && apt-get install --no-install-recommends -yq \
  google-chrome-stable=99.0.4844.51-1 \
  unzip && rm -rf /var/lib/apt/lists/*;
RUN wget -q https://chromedriver.storage.googleapis.com/99.0.4844.51/chromedriver_linux64.zip
RUN unzip chromedriver_linux64.zip

RUN mv chromedriver /usr/bin/chromedriver
RUN chown root:root /usr/bin/chromedriver
RUN chmod +x /usr/bin/chromedriver

RUN wget -q https://selenium-release.storage.googleapis.com/3.13/selenium-server-standalone-3.13.0.jar
RUN wget -q https://www.java2s.com/Code/JarDownload/testng/testng-6.8.7.jar.zip
RUN unzip testng-6.8.7.jar.zip

# Install DocSearch dependencies
COPY Pipfile .
COPY Pipfile.lock .

ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8
ENV PIPENV_HIDE_EMOJIS 1
RUN apt-get update -y && apt-get install --no-install-recommends -yq \
    python3-pip && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir pipenv
RUN pipenv install --python 3.6