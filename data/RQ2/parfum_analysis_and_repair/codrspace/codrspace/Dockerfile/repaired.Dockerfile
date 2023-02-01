FROM python:2.7.14-slim

RUN apt-get update && \
    apt-get install --no-install-recommends -y git-core && \
    apt-get install --no-install-recommends -y libmysqlclient-dev && \
    apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;

ADD requirements_dev.pip /tmp/requirements_dev.pip
RUN pip install --no-cache-dir -r /tmp/requirements_dev.pip && rm /tmp/requirements_dev.pip

WORKDIR /code/codrspace_app