FROM python:3.7

RUN apt-get update -y && \
    apt-get install --no-install-recommends -y \
        python-pip \
        wget \
        && apt-get clean -y && \
        rm -rf /var/lib/apt/lists/*

COPY requirements.txt /tmp/pip-tmp/
COPY azureml_contrib_automl_dnn_vision-1.22.0-py3-none-any.whl /tmp/
RUN pip3 --disable-pip-version-check --no-cache-dir install -r /tmp/pip-tmp/requirements.txt \
    && rm -rf /tmp/pip-tmp

RUN pip install --no-cache-dir /tmp/azureml_contrib_automl_dnn_vision-1.22.0-py3-none-any.whl#PyPi broken
RUN pip install --no-cache-dir -U scikit-learn#Fix ImportError: cannot import name '_NAN_METRICS' from 'sklearn.metrics.pairwise

RUN mkdir -p /usr/src/api && rm -rf /usr/src/api
RUN mkdir -p /usr/src/api/powerskill && rm -rf /usr/src/api/powerskill
RUN mkdir -p /usr/src/api/models && rm -rf /usr/src/api/models
RUN mkdir -p /usr/src/api/thumbnails && rm -rf /usr/src/api/thumbnails

WORKDIR /usr/src/api

COPY models /usr/src/api/models/
COPY powerskill /usr/src/api/powerskill/
COPY app.py /usr/src/api/
COPY config.json /usr/src/api/

# https://docs.microsoft.com/en-gb/azure/app-service/configure-custom-container?pivots=container-linux#enable-ssh
EXPOSE 80 2222
EXPOSE 5000

ADD startup.sh /
RUN chmod +x /startup.sh

CMD ["/startup.sh"]
