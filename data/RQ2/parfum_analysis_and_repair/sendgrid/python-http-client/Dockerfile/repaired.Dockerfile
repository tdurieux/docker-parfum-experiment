FROM ubuntu:xenial
ENV PYTHON_VERSIONS='python2.7 python3.4 python3.5 python3.6 python3.7' \
    OAI_SPEC_URL="https://raw.githubusercontent.com/sendgrid/sendgrid-oai/HEAD/oai_stoplight.json"

# install testing versions of python, including old versions, from deadsnakes
RUN set -x \
    && apt-get update \
    && apt-get install -y --no-install-recommends software-properties-common \
    && apt-add-repository -y ppa:fkrull/deadsnakes \
    && apt-get update \
    && apt-get install -y --no-install-recommends $PYTHON_VERSIONS \
        git \
        curl \
    && apt-get purge -y --auto-remove software-properties-common \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /root

# install Prism
ADD https://raw.githubusercontent.com/stoplightio/prism/HEAD/install.sh install.sh
RUN chmod +x ./install.sh && \
    ./install.sh && \
    rm ./install.sh

# install pip, tox
ADD https://bootstrap.pypa.io/get-pip.py get-pip.py
RUN python2.7 get-pip.py && \
    pip install --no-cache-dir tox && \
    rm get-pip.py

# set up default Twilio SendGrid env
WORKDIR /root/sources
RUN git clone https://github.com/sendgrid/sendgrid-python.git && \
    git clone https://github.com/sendgrid/python-http-client.git
WORKDIR /root
RUN ln -s /root/sources/sendgrid-python/sendgrid && \
    ln -s /root/sources/python-http-client/python_http_client

COPY . .
CMD sh run.sh
