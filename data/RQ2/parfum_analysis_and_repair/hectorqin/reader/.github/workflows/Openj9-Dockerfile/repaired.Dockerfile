FROM ibm-semeru-runtimes:open-8u332-b09-jre
# Install base packages
RUN \
    apt-get update; \
    apt-get install --no-install-recommends -y ca-certificates tini tzdata; \
    update-ca-certificates; \
    # Clean apt cache
    rm -rf /var/lib/apt/lists/*

# 时区
ENV TZ=Asia/Shanghai

EXPOSE 8080
ENTRYPOINT ["/usr/bin/tini", "--"]
ADD ./reader.jar /app/bin/reader.jar
CMD ["java", "-jar", "/app/bin/reader.jar" ]
