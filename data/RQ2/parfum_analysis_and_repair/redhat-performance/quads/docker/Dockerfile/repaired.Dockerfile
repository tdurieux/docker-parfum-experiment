FROM python:3

RUN apt-get update && \
    apt-get -y --no-install-recommends install \
    ipmitool \
    git && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir \
    cherrypy \
    pyyaml \
    mongoengine \
    requests \
    ipdb \
    python-wordpress-xmlrpc \
    gitpython \
    flake8 \
    paramiko \
    jinja2 \
    aiohttp \
    pexpect \
    argcomplete

RUN mkdir -p /var/www/html/visual
RUN mkdir -p /var/www/html/cloud

WORKDIR /opt/quads
ENV PYTHONPATH=/opt/quads
ENTRYPOINT python bin/quads-server
