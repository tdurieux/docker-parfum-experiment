FROM openjdk:8-jre-slim

WORKDIR /app/streama

RUN apt-get -y update && \
    apt-get -y --no-install-recommends install curl && \
    apt-get -y clean && \
    apt-get -y autoremove && \
    URL_DOWNLOAD_LATEST_RELEASE=$( curl -f -L https://api.github.com/repos/streamaserver/streama/releases | grep -i browser_download_url | head -n 1 | cut -d '"' -f 4) && \
    curl -f -o streama.jar -L $URL_DOWNLOAD_LATEST_RELEASE && \
    chmod u+x streama.jar && rm -rf /var/lib/apt/lists/*;

EXPOSE 8080

ENTRYPOINT [ "java", "-jar", "streama.jar" ]
