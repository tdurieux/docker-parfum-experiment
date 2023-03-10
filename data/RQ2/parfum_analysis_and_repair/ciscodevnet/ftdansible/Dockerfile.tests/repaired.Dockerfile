ARG PYTHON_VERSION=3.6
FROM python:${PYTHON_VERSION}

COPY requirements.txt /requirements.txt

RUN pip download $(grep ^ansible /requirements.txt) --no-cache-dir --no-deps -d /tmp/pip && \
    mkdir /tmp/ansible && \
    tar -C /tmp/ansible -xf /tmp/pip/ansible* && \
    mv /tmp/ansible/ansible* /ansible && \
    rm -rf /tmp/pip /tmp/ansible

COPY test-requirements.txt /test-requirements.txt

RUN pip install \
    --no-cache-dir \
    -c /ansible/test/runner/requirements/constraints.txt \
    -r /test-requirements.txt \
    -r /requirements.txt

ENV PYTHONPATH="$PYTHONPATH:/ansible/lib:/ansible/test"

COPY . /ftd-ansible

WORKDIR /ftd-ansible

ENTRYPOINT ["pytest"]

CMD ["test"]