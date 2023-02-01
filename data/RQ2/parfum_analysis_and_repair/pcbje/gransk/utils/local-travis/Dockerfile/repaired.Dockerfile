FROM ubuntu:14.04
MAINTAINER Petter Chr. Bjelland <post@pcbje.com>

ADD gransk/web/tests/package.json /app/gransk/web/tests/package.json
ADD utils/dfvfs-requirements.txt /app/utils/
ADD requirements.txt /app/
WORKDIR /app

RUN apt-get update
RUN apt-get install --no-install-recommends --force-yes -y build-essential make curl git && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sL https://deb.nodesource.com/setup_0.12 | sudo bash -
RUN apt-get install --no-install-recommends --force-yes -y \
    python-pip python3.4 python3-pip nodejs python-dev \
    zlib1g-dev unzip p7zip-full p7zip-rar libicu-dev poppler-utils ghostscript \
    fontconfig rubygems-integration && rm -rf /var/lib/apt/lists/*;

RUN gem install coveralls-lcov

# libewf bzip2 dependency error hack
RUN apt-get remove --purge -y bzip2 libbz2-dev
RUN pip install --no-cache-dir -r utils/dfvfs-requirements.txt
RUN pip3 install --no-cache-dir -r utils/dfvfs-requirements.txt
RUN apt-get install --no-install-recommends --force-yes -y bzip2 libbz2-dev && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir -r requirements.txt
RUN pip3 install --no-cache-dir -r requirements.txt

RUN cp gransk/web/tests/package.json /opt && npm install --prefix=/opt /opt && npm cache clean --force;
