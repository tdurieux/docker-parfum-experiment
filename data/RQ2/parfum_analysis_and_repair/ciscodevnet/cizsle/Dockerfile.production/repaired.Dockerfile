# Cizsle Server - Production Docker Image
FROM python:3.6-alpine

ARG user=cizsle
ARG uid=25639
ARG group=cizsle
ARG gid=25639
ARG admin_dir=/admin


ENV LC_ALL=C.UTF-8 \
    LANG=C.UTF-8


# Ensure Python package installation tools are up-to-date
RUN pip install -q --upgrade --no-cache-dir pip setuptools wheel


# Setup directories and non-priviledged user
RUN mkdir -p $admin_dir && \
    addgroup -g $gid $group && \
    adduser -D -G $group -u $uid $user && \
    chown -R $user:$group $admin_dir && \
    chmod 755 $admin_dir
ENV PATH=/home/$user/.local/bin:$PATH
USER $user


# Install App
RUN pip install --user -q --no-cache-dir cizsle[server]


# Expose Volume(s) and set the working directory
VOLUME $admin_dir
WORKDIR $admin_dir


# Start the cizsle server