FROM python:3.7-alpine

LABEL "com.github.actions.name"="cryosat_toolkit"
LABEL "com.github.actions.description"="Run pytest commands"
LABEL "com.github.actions.icon"="upload-cloud"
LABEL "com.github.actions.color"="yellow"

RUN apk add --no-cache bash
RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir pytest pytest-cov
RUN pip install --no-cache-dir -r requirements.txt
RUN python --version ; pip --version ; pytest --version
