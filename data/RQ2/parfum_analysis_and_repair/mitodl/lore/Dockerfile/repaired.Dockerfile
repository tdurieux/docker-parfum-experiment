FROM ubuntu:trusty
MAINTAINER ODL DevOps <mitx-devops@mit.edu>

# Add package files
WORKDIR /tmp

# Install base packages
COPY apt.txt /tmp/apt.txt
RUN apt-get update && \
    apt-get install --no-install-recommends -y $(grep -vE "^\s*#" apt.txt  | tr "\n" " ") && \
    ln -s /usr/bin/nodejs /usr/bin/node && rm -rf /var/lib/apt/lists/*;

# Install pip
RUN curl -f --silent --location https://bootstrap.pypa.io/get-pip.py > get-pip.py && \
    python3 get-pip.py && \
    python get-pip.py

# Add non-root user.
RUN adduser --disabled-password --gecos "" mitodl

# Install project packages

# Python 2
COPY requirements.txt /tmp/requirements.txt
COPY test_requirements.txt /tmp/test_requirements.txt
COPY doc_requirements.txt /tmp/doc_requirements.txt
RUN pip install --no-cache-dir -r requirements.txt && \
    pip install --no-cache-dir -r test_requirements.txt && \
    pip install --no-cache-dir -r doc_requirements.txt

# Python 3
RUN pip3 install --no-cache-dir -r requirements.txt && \
    pip3 install --no-cache-dir -r test_requirements.txt

# Add project
COPY . /src
WORKDIR /src
RUN chown -R mitodl:mitodl /src

# Gather static
RUN ./manage.py collectstatic --noinput
RUN apt-get clean && apt-get purge
USER mitodl

# Set pip cache folder, as it is breaking pip when it is on a shared volume
ENV XDG_CACHE_HOME /tmp/.cache

# Set and expose port for uwsgi config
EXPOSE 8070
ENV PORT 8070
CMD if [ -n "$WORKER" ]; then celery -A lore worker; else uwsgi uwsgi.ini; fi
