FROM jenkinsci/blueocean

USER root
RUN apk add --no-cache py-pip && pip install --no-cache-dir docker-compose
USER jenkins

