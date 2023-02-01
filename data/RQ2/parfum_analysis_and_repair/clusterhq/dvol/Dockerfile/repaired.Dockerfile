FROM        ubuntu:14.04

# Last build date - this can be updated whenever there are security updates so
# that everything is rebuilt
ENV         security_updates_as_of 2015-08-10

# Install security updates and required packages
RUN apt-get -qy update && \
            apt-get -qy upgrade && \
            apt-get -qy --no-install-recommends install python-pip && \
            apt-get -qy --no-install-recommends install python-dev && \
            apt-get -qy --no-install-recommends install libyaml-dev && \
            apt-get -qy --no-install-recommends install libffi-dev && \
            apt-get -qy --no-install-recommends install libssl-dev && \
            pip install --no-cache-dir --upgrade pip setuptools && \
# Pre-install some requirements to make the next step hopefully faster
            pip install --no-cache-dir twisted==14.0.0 treq==0.2.1 service_identity pycrypto pyrsistent pyyaml==3.10 && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir docker-py

ADD         setup.py README.md /app/
ADD         dvol_python/* /app/dvol_python/

WORKDIR     /app

# Install requirements from the project's setup.py
RUN         python setup.py install

CMD         ["dvol-docker-plugin"]
VOLUME      ["/var/lib/dvol"]
