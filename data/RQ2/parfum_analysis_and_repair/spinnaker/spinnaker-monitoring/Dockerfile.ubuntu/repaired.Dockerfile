# This Dockerfile places the python server in /opt/spinnaker-monitoring/bin, and expects
# config to be mounted in /opt/spinnaker-monitoring/config, which includes the
# spinnaker-monitoring.yml file.
FROM ubuntu:bionic
LABEL maintainer="sig-platform@spinnaker.io"

RUN adduser --system --uid 10111 --group spinnaker
RUN apt-get update && apt-get install --no-install-recommends -y python python2.7 python-pip wget && rm -rf /var/lib/apt/lists/*;

COPY spinnaker-monitoring-daemon/requirements.txt /opt/spinnaker-monitoring/requirements.txt
WORKDIR /opt/spinnaker-monitoring

RUN sed -ie 's/#@ //g' requirements.txt
RUN pip install --no-cache-dir -r requirements.txt
ENV PYTHONWARNINGS "once"

COPY spinnaker-monitoring-daemon/spinnaker-monitoring /opt/spinnaker-monitoring/bin
USER spinnaker

ENTRYPOINT ["python", "/opt/spinnaker-monitoring/bin"]
CMD ["--config", "/opt/spinnaker-monitoring/config/spinnaker-monitoring.yml", "monitor"]
