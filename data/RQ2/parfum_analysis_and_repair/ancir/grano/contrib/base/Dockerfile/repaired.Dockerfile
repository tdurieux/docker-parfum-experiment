FROM python:2.7.15
MAINTAINER Code for Africa <support@codeforafrica.org>
ENV DEBIAN_FRONTEND noninteractive

# Setup Node.js
RUN curl -f -sL https://deb.nodesource.com/setup_6.x | bash -
RUN apt-get -q --no-install-recommends install -y nodejs && rm -rf /var/lib/apt/lists/*;

# Upgrade what we can
RUN pip install --no-cache-dir -q --upgrade pip && pip install --no-cache-dir -q --upgrade setuptools
