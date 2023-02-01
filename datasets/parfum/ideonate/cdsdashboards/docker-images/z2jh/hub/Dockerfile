ARG BASE_IMAGE=jupyterhub/k8s-hub:0.10.3
FROM $BASE_IMAGE

USER root

RUN mkdir /tmp/cdsdashboard_current

ADD . /tmp/cdsdashboard_current/

RUN cd /tmp/cdsdashboard_current \
        && python3 setup.py sdist \
        && python3 -m pip install ./`ls dist/cdsdashboards-*.tar.gz` \
        && cd .. && rm -rf ./cdsdashboard_current

# RUN python3 -m pip install --upgrade kubernetes==11.0.0

USER ${NB_USER}
