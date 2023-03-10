# Notable references
# - http://www.projectatomic.io/blog/2014/09/running-syslog-within-a-docker-container/

FROM python:3
LABEL application="behave_test"

# Run as non root user
RUN useradd --no-log-init --create-home --uid 1000 --user-group behave
USER behave
ENV PATH="/home/behave/.local/bin:${PATH}:"

# Install dependencies (TODO: improve with python requirements.txt)
RUN pip install --no-cache-dir --user \
    behave \
    requests \
    pyhamcrest \
    jmespath \
    rfc5424-logging-handler \
    kafka-python \
    confluent-kafka

VOLUME /tmp/test
WORKDIR /tmp/test
CMD ["behave", "--junit", "--junit-directory", "/tmp/test/behave/reports", "behave/features"]
