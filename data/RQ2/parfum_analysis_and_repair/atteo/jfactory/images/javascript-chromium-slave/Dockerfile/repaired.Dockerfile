FROM jfactory/javascript-slave

USER root

RUN apt-get update && apt-get install --no-install-recommends -y chromium && rm -rf /var/lib/apt/lists/*

USER jenkins
