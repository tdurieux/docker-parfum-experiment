# Dockerfile
FROM python:3.7

ARG KILLRVIDEO_DOCKER_IP
ENV KILLRVIDEO_DOCKER_IP ${KILLRVIDEO_DOCKER_IP}

ARG KILLRVIDEO_HOST_IP
ENV KILLRVIDEO_HOST_IP ${KILLRVIDEO_HOST_IP}

ARG KILLRVIDEO_DSE_USERNAME
ENV KILLRVIDEO_DSE_USERNAME ${KILLRVIDEO_DSE_USERNAME}

ARG KILLRVIDEO_DSE_PASSWORD
ENV KILLRVIDEO_DSE_PASSWORD ${KILLRVIDEO_DSE_PASSWORD}

# Install app dependencies
RUN pip install --no-cache-dir dse-driver
RUN pip install --no-cache-dir dse-graph
RUN pip install --no-cache-dir protobuf
RUN pip install --no-cache-dir grpcio
RUN pip install --no-cache-dir python-etcd
RUN pip install --no-cache-dir time-uuid
RUN pip install --no-cache-dir validate-email
RUN pip install --no-cache-dir sortedcontainers
RUN pip install --no-cache-dir nltk
RUN python -m nltk.downloader stopwords
RUN pip install --no-cache-dir kafka-python

# Create app directory
COPY killrvideo/ /app
WORKDIR /app

ENV PYTHONPATH "${PYTHONPATH}:/${WORKDIR}"

EXPOSE 50101

CMD ["python", "./__init__.py"]
