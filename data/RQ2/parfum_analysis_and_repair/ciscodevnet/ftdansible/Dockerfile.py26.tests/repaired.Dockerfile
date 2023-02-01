FROM lovato/python-2.6

# SETUP SYSTEM PACKAGES
RUN apt-get update && apt-get -y --no-install-recommends install git wget build-essential libssl-dev libffi-dev libxml2-dev libxslt1-dev && rm -rf /var/lib/apt/lists/*;

# PREPARE PY2.6
RUN wget https://github.com/pypa/setuptools/archive/bootstrap-2.x.tar.gz && \
    tar -xvf bootstrap-2.x.tar.gz && \
    cd setuptools-bootstrap-2.x && \
    python2.6 setup.py install && rm bootstrap-2.x.tar.gz

RUN wget https://github.com/pypa/pip/archive/9.0.3.tar.gz && \
    tar -xvf 9.0.3.tar.gz && \
    cd pip-9.0.3 && \
    python2.6 setup.py install && rm 9.0.3.tar.gz

# CLONE ANSIBLE
COPY requirements.txt /requirements.txt

RUN pip download $(grep ^ansible /requirements.txt) --no-cache-dir --no-deps -d /tmp/pip && \
    mkdir /tmp/ansible && \
    tar -C /tmp/ansible -xf /tmp/pip/ansible* && \
    mv /tmp/ansible/ansible* /ansible && \
    rm -rf /tmp/pip /tmp/ansible

# INSTALL ANSIBLE REQUIREMENTS
RUN python2.6 /usr/local/bin/pip install pycparser==2.18 idna==2.7 cryptography==2.0 lxml==4.2.6 && \
    python2.6 /usr/local/bin/pip install \
    --disable-pip-version-check \
    -c /ansible/test/runner/requirements/constraints.txt \
    -r /ansible/test/runner/requirements/units.txt

# INSTALL FTD-ANSIBLE REQUIREMENTS
COPY test-requirements.txt /test-requirements.txt

RUN python2.6 /usr/local/bin/pip install \
    --disable-pip-version-check \
    --no-cache-dir \
    -c /ansible/test/runner/requirements/constraints.txt \
    -r /test-requirements.txt \
    -r /requirements.txt

# SETUP ENV
ENV PYTHONPATH="$PYTHONPATH:/ansible/lib:/ansible/test"

COPY . /ftd-ansible

WORKDIR /ftd-ansible

ENTRYPOINT ["pytest"]

CMD ["test"]
