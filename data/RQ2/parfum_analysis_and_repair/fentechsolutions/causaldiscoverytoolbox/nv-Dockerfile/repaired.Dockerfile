FROM fentechai/nv-cdt-env-base:22.02
MAINTAINER Diviyan Kalainathan <diviyan@lri.fr>
LABEL description="Nvidia Docker image for the Causal Discovery Toolbox"
ARG python

RUN mkdir -p /CDT
COPY . /CDT
RUN cd /CDT && \
    python3 -m pip install -r requirements.txt && \
    python3 -m pip install pytest pytest-cov && \
    python3 -m pip install codecov && \
    python3 setup.py install
CMD /bin/sh