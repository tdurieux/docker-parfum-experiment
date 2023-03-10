FROM amazonlinux

LABEL maintainer="a.leon.escalera@accenture.com"

# Install Python dependencies
RUN yum -y install epel-release && yum -y install \
        gcc \
        gcc-c++ \
        python-devel \
        atlas \
        atlas-devel \
        gcc-gfortran \
        openssl-devel \
        libffi-devel \
        findutils.x86_64 \
        perl-File-pushd.noarch \
        zip && \
#
# Install pip
    curl -f -O https://bootstrap.pypa.io/get-pip.py && \
    python get-pip.py && \
    rm get-pip.py && \
#
# Install and run virtualenv
    pip install --no-cache-dir --upgrade virtualenv && \
    virtualenv -p /usr/bin/python /venv && rm -rf /var/cache/yum

CMD [ "/bin/sh" ]
