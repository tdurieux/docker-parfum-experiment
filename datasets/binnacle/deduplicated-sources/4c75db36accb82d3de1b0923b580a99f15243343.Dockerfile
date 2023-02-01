# Dockerfile for development
# Based on the production Dockerfile, but with development additions.
# Keep this file as close as possible to the production Dockerfile, so the environments match.

FROM python:3.5
MAINTAINER Paulus Schoutsen <Paulus@PaulusSchoutsen.nl>

# Uncomment any of the following lines to disable the installation.
#ENV INSTALL_TELLSTICK no
#ENV INSTALL_OPENALPR no
#ENV INSTALL_FFMPEG no
#ENV INSTALL_OPENZWAVE no
#ENV INSTALL_LIBCEC no
#ENV INSTALL_PHANTOMJS no

VOLUME /config

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

# Copy build scripts
COPY virtualization/Docker/ virtualization/Docker/
RUN virtualization/Docker/setup_docker_prereqs

# Install hass component dependencies
COPY requirements_all.txt requirements_all.txt
RUN pip3 install --no-cache-dir -r requirements_all.txt && \
    pip3 install --no-cache-dir mysqlclient psycopg2 uvloop

# BEGIN: Development additions

# Install nodejs
RUN curl -sL https://deb.nodesource.com/setup_7.x | sudo -E bash - && \
    apt-get install -y nodejs

# Install tox
RUN pip3 install --no-cache-dir tox

# Copy over everything required to run tox
COPY requirements_test.txt setup.cfg setup.py tox.ini ./
COPY homeassistant/const.py homeassistant/const.py

# Prefetch dependencies for tox
RUN tox -e py35 --notest

# END: Development additions

# Copy source
COPY . .

CMD [ "python", "-m", "homeassistant", "--config", "/config" ]