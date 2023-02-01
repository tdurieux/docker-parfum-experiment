FROM ubuntu:18.04
USER root

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update
RUN apt-get install --no-install-recommends -y software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN apt-get update

RUN apt-get install --no-install-recommends -y build-essential python3.6 python3.6-dev python3-pip python3.6-venv && rm -rf /var/lib/apt/lists/*;
RUN python3.6 -m pip install pip --upgrade

RUN apt-get install --no-install-recommends -y tcl tk python3.6-tk wget python-opencv python3-distutils git && rm -rf /var/lib/apt/lists/*;
RUN wget https://bootstrap.pypa.io/get-pip.py
RUN python3.6 get-pip.py

# Default to Python 3.6
RUN rm /usr/bin/python
RUN ln -s /usr/bin/python3.6 /usr/bin/python

# Removing existing __pycache__ files
RUN find . -type d -name __pycache__ -exec rm -r {} \+

# Interface
COPY ./interface/requirements /requirements/interface
RUN pip install --no-cache-dir -U pip
RUN pip install --no-cache-dir -r /requirements/interface/local.txt

# Prediction
COPY ./prediction/.pylidcrc /root/.pylidcrc
COPY ./prediction/requirements/torch.txt /requirements/prediction/torch.txt
RUN pip install --no-cache-dir -r /requirements/prediction/torch.txt
COPY ./prediction/requirements/local.txt /requirements/prediction/local.txt
RUN pip install --no-cache-dir -r /requirements/prediction/local.txt
COPY ./prediction/requirements/base.txt /requirements/prediction/base.txt
RUN pip install --no-cache-dir -r /requirements/prediction/base.txt

# Documentation
COPY ./docs/requirements.txt /requirements/requirements.txt
RUN pip install --no-cache-dir -r /requirements/requirements.txt


WORKDIR /app
