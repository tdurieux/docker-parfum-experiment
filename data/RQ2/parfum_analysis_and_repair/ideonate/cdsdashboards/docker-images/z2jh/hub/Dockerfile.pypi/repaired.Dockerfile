ARG BASE_IMAGE=jupyterhub/k8s-hub:0.10.3
FROM $BASE_IMAGE

ARG CDSVERSION=0.4.0

USER root

RUN python3 -m pip install --upgrade cdsdashboards>=$CDSVERSION

USER ${NB_USER}