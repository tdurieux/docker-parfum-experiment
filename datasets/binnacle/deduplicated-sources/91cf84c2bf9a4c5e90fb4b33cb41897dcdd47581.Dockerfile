FROM python:3.7-slim-stretch

MAINTAINER bhearsum@mozilla.com

# netcat is needed for health checks
# Some versions of the python:3.7 Docker image remove libpcre3, which uwsgi needs for routing support to be enabled.
# default-libmysqlclient-dev is required to use SQLAlchemy with MySQL
# mysql-client is needed to import sample data
# curl is needed to pull sample data
# gcc is needed to compile some python packages
# xz-utils is needed to unpack sampled ata
# git is needed to send coverage reports
RUN apt-get -q update \
    && apt-get -q --yes install netcat libpcre3 libpcre3-dev default-libmysqlclient-dev mysql-client curl gcc xz-utils git \
    && apt-get clean

WORKDIR /app

# The general app requirements and packages required to run Tox are installed into the system.
# We copy them in early to avoid re-installing them unless absolutely necessary.
COPY requirements.txt requirements-tox.txt /app/
RUN pip install -r requirements.txt
RUN pip install -r requirements-tox.txt

COPY aus-data-snapshots/ /app/aus-data-snapshots/
COPY auslib/ /app/auslib/
COPY ui/ /app/ui/
COPY scripts/ /app/scripts/
COPY uwsgi/ /app/uwsgi/
COPY .coveragerc MANIFEST.in requirements-test.txt setup.py tox.ini version.json version.txt /app/
# we need .git to gather information for coverage reports
COPY .git/ /app/.git/

# Using /bin/bash as the entrypoint works around some volume mount issues on Windows
# where volume-mounted files do not have execute bits set.
# https://github.com/docker/compose/issues/2301#issuecomment-154450785 has additional background.
ENTRYPOINT ["/bin/bash", "/app/scripts/run.sh"]
CMD ["public"]
