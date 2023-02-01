ARG WAVE_IMAGE
FROM ${WAVE_IMAGE}

ARG uid

USER root

RUN apt-get -q -y update && apt-get install --no-install-recommends -q -y openjdk-11-jre && rm -rf /var/lib/apt/lists/*;

USER ${uid}

WORKDIR /app
