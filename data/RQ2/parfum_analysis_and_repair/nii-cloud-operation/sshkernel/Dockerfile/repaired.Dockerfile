FROM jupyter/minimal-notebook:latest

USER root

RUN apt-get update \
  && apt-get install --no-install-recommends -yq openssh-server && rm -rf /var/lib/apt/lists/*;

USER jovyan

ADD requirements.txt /tmp/
RUN pip install --no-cache-dir -r /tmp/requirements.txt

ADD --chown=jovyan:users . /tmp/ssh

RUN pip install --no-cache-dir -e /tmp/ssh

RUN python -msshkernel install --sys-prefix
