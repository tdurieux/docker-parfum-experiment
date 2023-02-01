FROM java:8

RUN apt-get update && apt-get -y --no-install-recommends -q install libreoffice libreoffice-writer ure libreoffice-java-common libreoffice-core libreoffice-common && rm -rf /var/lib/apt/lists/*;
