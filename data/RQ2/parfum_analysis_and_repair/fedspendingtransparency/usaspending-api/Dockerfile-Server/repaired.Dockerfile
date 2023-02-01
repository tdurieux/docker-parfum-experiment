ARG api_image=usaspending-api:latest
FROM $api_image
RUN yum install -y \
    git \
    gcc-c++ \
    postgresql-devel \
    pcre \
    pcre-devel \
    mlocate \
    wget \
    unzip \
    bzip2-devel && rm -rf /var/cache/yum
COPY requirements/requirements-server.txt requirements/requirements-server.txt
RUN python3 -m pip install -r requirements/requirements-server.txt ansible==2.9.15 awscli
