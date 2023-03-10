FROM ubuntu:14.04
MAINTAINER Codey oxley <codey.a.oxley+os@gmail.com>
EXPOSE 8990

# These are the supported environment variables.
# Use them to control the 'default' Django database configuration:
#     DB_ENGINE
#     DB_NAME
#     DB_USER
#     DB_PASSWORD
#     DB_HOST
#     DB_PORT
#
#     NSOT_EMAIL
#     NSOT_SECRET

# Install necessary packages
#
# The development packages are for building certain dependencies that pip pulls
# in
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get --quiet=2 update
RUN apt-get --quiet=2 --no-install-recommends install -y \
        python \
        python-dev \
        python-pip \
        libffi6 \
        libffi-dev \
        libssl-dev \
        libmysqlclient-dev \
        curl && rm -rf /var/lib/apt/lists/*;

RUN apt-get --quiet=2 --no-install-recommends install -y python-psycopg2 && rm -rf /var/lib/apt/lists/*;
RUN apt-get --quiet=2 --no-install-recommends install -y sqlite3 && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir MySQL-Python
RUN pip install --no-cache-dir psycopg2
# upgrade pip to fix https://github.com/dropbox/nsot/issues/277
RUN pip install --no-cache-dir -U setuptools

# Try to run this as late as possible for layer caching - this version will be
# updated every update so let the build not take longer than necessary
RUN pip install --no-cache-dir nsot=={{ NSOT_VERSION }}
COPY conf /etc/nsot

ENTRYPOINT ["nsot-server", "--config=/etc/nsot/nsot.conf.py"]

# If using --no-upgrade then the database won't be built for first run. Use
# should specify --no-upgrade manually if they don't want it
CMD ["start", "--noinput"]
# CMD ["start", "--noinput", "--no-upgrade"]
