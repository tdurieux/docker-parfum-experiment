FROM python:3-alpine
USER root
RUN adduser -D kfkuser
RUN pip install --no-cache-dir strimzi-kafka-cli==0.1.0a62
USER kfkuser
RUN kfk --version