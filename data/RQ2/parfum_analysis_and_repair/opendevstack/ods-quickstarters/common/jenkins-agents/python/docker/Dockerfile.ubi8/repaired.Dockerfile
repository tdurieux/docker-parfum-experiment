FROM opendevstackorg/ods-jenkins-agent-base-ubi8:latest

LABEL maintainer="Gerard Castillo <gerard.castillo@boehringer-ingelheim.com>"

ARG nexusHost
ARG nexusAuth

ENV PYTHONUNBUFFERED=1 \
    PYTHONIOENCODING=UTF-8 \
    PIP_NO_CACHE_DIR=off \
    PATH=$JAVA_HOME/bin:$PATH

RUN yum module install -y python38:3.8/build && \
    yum -y clean all && \
    ln -s /usr/bin/pip3.8 /usr/bin/pip

RUN if [ ! -z ${nexusHost} ] && [ ! -z ${nexusAuth} ]; \
    then pip config set global.index-url https://${nexusAuth}@${nexusHost}/repository/pypi-all/simple \
        && pip config set global.trusted-host ${nexusHost} \
        && pip config set global.extra-index-url https://pypi.org/simple; \
    fi; \
    pip config set global.cert /etc/ssl/certs/ca-bundle.crt && \
    pip install --no-cache-dir --upgrade pip --user && \
    pip install --no-cache-dir virtualenv==20.4.6 setuptools==56.1.0 Cython==0.29.23 pypandoc==1.5

# Enables default user to access $HOME folder
RUN chown -R 1001:0 $HOME && \
    chmod -R a+rw $HOME

USER 1001
