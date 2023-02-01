FROM ubuntu:18.04

RUN apt-get update -y && apt-get -y --no-install-recommends install curl gnupg2 software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN curl -f -OL https://download.arangodb.com/arangodb34/DEBIAN/Release.key
RUN apt-key add Release.key
RUN apt-add-repository 'deb https://download.arangodb.com/arangodb34/DEBIAN/ /'
RUN apt-get update -y && apt-get -y --no-install-recommends install arangodb3 && rm -rf /var/lib/apt/lists/*;

COPY catalyst /app/catalyst
CMD /app/catalyst

EXPOSE 8000
