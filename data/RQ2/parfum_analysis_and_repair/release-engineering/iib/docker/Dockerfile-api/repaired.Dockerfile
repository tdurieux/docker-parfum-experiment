FROM registry.access.redhat.com/ubi8/ubi:latest
LABEL maintainer="Red Hat - EXD"

WORKDIR /src
# openssl-devel is required when compiling python-qpid-proton to support SSL
RUN dnf -y install \
    --setopt=deltarpm=0 \
    --setopt=install_weak_deps=false \
    --setopt=tsflags=nodocs \
    gcc \
    httpd \
    krb5-devel \
    libffi-devel \
    libpq-devel \
    mod_auth_gssapi \
    mod_ssl \
    python38-mod_wsgi \
    openssl-devel \
    python38-devel \
    python38-pip \
    python38-wheel \
    && dnf update -y \
    && dnf clean all
RUN update-alternatives --set python3 $(which python3.8)
COPY . .
COPY ./docker/iib-httpd.conf /etc/httpd/conf/httpd.conf

# default python3-pip version for rhel8 python3.8 is 19.3.1 and it can't be updated by dnf
# we have to update it by pip to version above 21.0.0
RUN pip3 install --no-cache-dir --upgrade pip
RUN pip3 install --no-cache-dir -r requirements.txt --no-deps --require-hashes
RUN pip3 install --no-cache-dir . --no-deps
EXPOSE 8080
CMD ["/usr/sbin/httpd", "-DFOREGROUND"]
