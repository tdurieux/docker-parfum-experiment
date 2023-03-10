FROM python:3.9
LABEL maintainer="virtualda@gmail.com"

ARG PIP_INDEX_URL

ENV PIP_INDEX_URL $PIP_INDEX_URL

COPY ./sample_service /opt/apps/sample_service/sample_service
COPY ./setup.py /opt/apps/sample_service/setup.py

RUN ((cd /opt/apps/sample_service && python3.6 -m pip --no-cache-dir install -e .) && \
     rm -rf /root/.cache/pip)

EXPOSE 8080

# Pass in command as argument at runtime
#CMD pserve $CONFIG_FILE --reload