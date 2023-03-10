# This will be set by the caller to whatever the tag for the
# container image created by Dockerfile.web is.
ARG DOCKERFILE_WEB

FROM $DOCKERFILE_WEB

# Note that we are running Celery without a heartbeat as
# per https://www.cloudamqp.com/docs/celery.html, to reduce
# messaging costs when using AMQP.