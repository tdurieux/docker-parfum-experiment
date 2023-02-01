FROM centos/python-36-centos7

LABEL maintainer="Guillaume Core (fridim) <gucore@redhat.com>"

USER root

RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir ansible
RUN pip install --no-cache-dir \
    openstacksdk \
    python-heatclient \
    python-openstackclient \
    dnspython


USER ${USER_ID}