# --------------------------------------------------------------------------
# This is a Dockerfile to build an Ubuntu 14.04 Docker image with
# pymssql and FreeTDS
#
# Use a command like:
#     docker build -t pymssql/pymssql .
# --------------------------------------------------------------------------

FROM  orchardup/python:2.7
MAINTAINER  Marc Abramowitz <marc@marc-abramowitz.com> (@msabramo)

# Install apt packages
RUN apt-get update && apt-get install --no-install-recommends -y \
    freetds-bin \
    freetds-common \
    freetds-dev && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir Cython
RUN pip install --no-cache-dir ipython
RUN pip install --no-cache-dir SQLAlchemy
RUN pip install --no-cache-dir pandas
RUN pip install --no-cache-dir Alembic
RUN pip install --no-cache-dir pytest pytest-timeout
RUN pip install --no-cache-dir gevent

# Add source directory to Docker image
# Note that it's beneficial to put this as far down in the Dockerfile as
# possible to maximize the chances of being able to use image caching
ADD . /opt/src/pymssql/

RUN pip install --no-cache-dir /opt/src/pymssql

CMD ["ipython"]
