FROM henningn/selenium-standalone-firefox
USER root

# Install curl
RUN apt-get update -qqy \
  && apt-get -qqy --no-install-recommends install \
    curl && rm -rf /var/lib/apt/lists/*;

# install uuid
RUN apt-get update -qqy \
  && apt-get -qqy --no-install-recommends install \
    uuid && rm -rf /var/lib/apt/lists/*;

RUN apt-get update -qqy \
  && apt-get -qqy --no-install-recommends install \
    cmake && rm -rf /var/lib/apt/lists/*;

# install openssl
RUN apt-get update -qqy \
  && apt-get -qqy --no-install-recommends install \
    libssl-dev && rm -rf /var/lib/apt/lists/*;

# install libgit2
RUN apt-get update && wget https://github.com/libgit2/libgit2/archive/v0.27.0.tar.gz \
  && tar xzf v0.27.0.tar.gz \
  && cd libgit2-0.27.0/ \
  && cmake . \
  && make \
  && sudo make install && rm v0.27.0.tar.gz

# Install Mysql
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update -qqy \
  && apt-get -qqy --no-install-recommends install \
    mysql-server \
    libmysqlclient-dev && rm -rf /var/lib/apt/lists/*;

# Install git
RUN apt-get -qqy --no-install-recommends \
  install git && rm -rf /var/lib/apt/lists/*;

# Install nodejs v8
RUN curl -f -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get update -qqy \
  && apt-get -qqy --no-install-recommends install \
    nodejs && rm -rf /var/lib/apt/lists/*;

# Install yarn
RUN curl -f -o- -L https://yarnpkg.com/install.sh | bash -

# Update to firefox nightly
ARG FIREFOX_DOWNLOAD_URL=https://download.mozilla.org/?product=firefox-nightly-latest-ssl&lang=en-US&os=linux64
RUN wget --no-verbose -O /tmp/firefox.tar.bz2 $FIREFOX_DOWNLOAD_URL \
  && apt-get -y purge firefox \
  && rm -rf /opt/firefox \
  && tar -C /opt -xjf /tmp/firefox.tar.bz2 \
  && rm /tmp/firefox.tar.bz2 \
  && mv /opt/firefox /opt/firefox-nightly \
  && ln -fs /opt/firefox-nightly/firefox /usr/bin/firefox

# Install python
RUN apt-get update -qqy \
  && apt-get -qqy --no-install-recommends install \
    python-pip \
    python-dev \
    build-essential \
  && pip install --no-cache-dir --upgrade pip && rm -rf /var/lib/apt/lists/*;

# Install Tox
RUN pip install --no-cache-dir tox

ENV USER=seluser

WORKDIR /code

USER seluser

EXPOSE 5900
EXPOSE 4444
