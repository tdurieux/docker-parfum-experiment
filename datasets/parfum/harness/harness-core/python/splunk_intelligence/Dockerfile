FROM python:2.7-slim
COPY VERSION dist/splunk_pyml /home/harness/
WORKDIR /home/harness
ENV SPLUNKML_ROOT /home/harness
ARG new_relic_key
ARG server_url
ARG service_secret
ARG https_port
RUN apt-get update && apt-get install -y make \
    build-essential ntp \
    libssl-dev && \
    pip install -r requirements.txt  && \
    make init-docker && \
    apt-get remove -y build-essential && \
    python -m nltk.downloader punkt && \
    sed -i 's#new_relic_key#'"$new_relic_key"'#g' newrelic.ini && \
    rm -rf /var/lib/apt/lists/* /root/.cache/
CMD ./run_learning_engine.sh --server_url ${server_url} --service_secret ${service_secret} --https_port ${https_port}

# for now, we build toli/harness-learning-engine, in the future, will build harness/learning-engine
# to build: make clean dist; docker build -t toli/harness-learning-engine .

# the equivalent of dist, ie python compilation, should be done inside Docker built; this could be a multi-stage build
# copy the python files and compile; then copy only the .pyc files into second stage to be smaller
