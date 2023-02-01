FROM python:3.8

RUN pip3 install --no-cache-dir ostorlab


RUN ostorlab agent run --name sampleagent --file ostorlab.yaml