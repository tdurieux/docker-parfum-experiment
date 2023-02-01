# Dockerfile for development
# Based on the production Dockerfile, but with development additions.
# Keep this file as close as possible to the production Dockerfile, so the environments match.

FROM python:3.7
LABEL maintainer="Paulus Schoutsen <Paulus@PaulusSchoutsen.nl>"

# Uncomment any of the following lines to disable the installation.
#ENV INSTALL_TELLSTICK no
#ENV INSTALL_OPENALPR no
#ENV INSTALL_FFMPEG no
#ENV INSTALL_LIBCEC no
#ENV INSTALL_COAP no
#ENV INSTALL_SSOCR no
#ENV INSTALL_DLIB no
#ENV INSTALL_IPERF3 no

VOLUME /config

WORKDIR /usr/src/app

# Copy build scripts
COPY virtualization/Docker/ virtualization/Docker/
RUN virtualization/Docker/setup_docker_prereqs

# Install hass component dependencies
COPY requirements_all.txt requirements_all.txt

RUN pip3 install --no-cache-dir -r requirements_all.txt && \
    pip3 install --no-cache-dir mysqlclient psycopg2 uvloop==0.12.2 cchardet cython

# BEGIN: Development additions

# Install git
RUN apt-get update \
  && apt-get install -y --no-install-recommends git \
  && rm -rf /var/lib/apt/lists/*

# Install nodejs
RUN curl -sL https://deb.nodesource.com/setup_7.x | bash - && \
    apt-get install -y nodejs

# Install tox
RUN pip3 install --no-cache-dir tox

# Copy over everything required to run tox
COPY requirements_test_all.txt setup.cfg setup.py tox.ini ./
COPY homeassistant/const.py homeassistant/const.py

# Prefetch dependencies for tox
COPY homeassistant/package_constraints.txt homeassistant/package_constraints.txt
RUN tox -e py37 --notest

# END: Development additions

# Copy source
COPY . .

EXPOSE 8123
EXPOSE 8300
EXPOSE 51827

CMD [ "python", "-m", "homeassistant", "--config", "/config" ]
