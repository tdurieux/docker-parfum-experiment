FROM python:3.6
RUN apt-get -y update && apt-get upgrade -yu
COPY . /tmp/SpiffWorkflow
RUN cd /tmp/SpiffWorkflow && make wheel && pip install --no-cache-dir dist/SpiffWorkflow*.whl
