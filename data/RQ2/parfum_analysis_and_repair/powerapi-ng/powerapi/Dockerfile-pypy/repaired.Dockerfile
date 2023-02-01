FROM pypy:3.6

RUN useradd -d /opt/powerapi -m powerapi
WORKDIR /opt/powerapi
USER powerapi

COPY --chown=powerapi . /tmp/powerapi

RUN cd /tmp/powerapi &&\
	wget https://raw.githubusercontent.com/powerapi-ng/powerapi-ci-env/main/to_36.sh && \
	/bin/bash to_36.sh powerapi

RUN pypy3 -m pip install --user --no-cache-dir "/tmp/powerapi[mongodb, influxdb, opentsdb, prometheus, influxdb2]" && \
	rm -r /tmp/powerapi

ENTRYPOINT ["/bin/echo", "This Docker image should be used as a base for another image and should not be executed directly."]