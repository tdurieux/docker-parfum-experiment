FROM cubesky/ssh-with-java

RUN apt update && apt-get -y --no-install-recommends install unzip && rm -rf /var/lib/apt/lists/*;

ARG archive
COPY target/${archive}.zip /opt/${archive}.zip

WORKDIR /opt/
RUN unzip ${archive}.zip

WORKDIR /opt/${archive}/
RUN chmod +x startup.sh

EXPOSE 8080
ENTRYPOINT /opt/${archive}/startup.sh
