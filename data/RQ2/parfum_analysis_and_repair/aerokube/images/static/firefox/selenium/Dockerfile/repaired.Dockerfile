ARG VERSION
FROM selenoid/dev_firefox:$VERSION

RUN \
    apt-get update && \
    apt-get install --no-install-recommends -y openjdk-8-jre-headless && \
    apt-get clean && \
    rm -Rf /tmp/* && rm -rf /var/lib/apt/lists/*;

COPY selenium-server-standalone.jar /usr/share/selenium/
COPY entrypoint.sh /

USER selenium

EXPOSE 4444
ENTRYPOINT ["/entrypoint.sh"]
