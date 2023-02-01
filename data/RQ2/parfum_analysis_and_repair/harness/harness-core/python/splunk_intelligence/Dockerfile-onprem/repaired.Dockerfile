FROM python:2.7-slim
COPY VERSION dist/splunk_pyml /home/harness/
ENV SPLUNKML_ROOT /home/harness
WORKDIR /home/harness
ARG server_url
ARG service_secret
ARG https_port
RUN apt-get update && apt-get install --no-install-recommends -y make \
    build-essential ntp \
    libssl-dev && \
    make init-docker-onprem && \
    apt-get remove -y build-essential && \
    python -m nltk.downloader punkt && \
    rm -rf /var/lib/apt/lists/* /root/.cache/
CMD ls && ./run_learning_engine.sh --server_url ${server_url} --service_secret ${service_secret} --https_port ${https_port}

# to build: make clean dist; docker build -t toli/harness-learning-engine .

# the equivalent of dist, ie python compilation, should be done inside Docker built; this could be a multi-stage build
# copy the python files and compile; then copy only the .pyc files into second stage to be smaller