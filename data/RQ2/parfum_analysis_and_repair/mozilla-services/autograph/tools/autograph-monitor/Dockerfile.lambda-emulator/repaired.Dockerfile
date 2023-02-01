FROM autograph-app

USER root

RUN cp /app/src/autograph/bin/test_monitor.sh /usr/local/bin/test_monitor.sh
RUN curl -f -Lo /usr/local/bin/aws-lambda-rie \
    https://github.com/aws/aws-lambda-runtime-interface-emulator/releases/latest/download/aws-lambda-rie \
    && \
    chmod +x /usr/local/bin/aws-lambda-rie /usr/local/bin/test_monitor.sh

USER app
CMD ["/usr/local/bin/aws-lambda-rie", "/go/bin/autograph-monitor"]
