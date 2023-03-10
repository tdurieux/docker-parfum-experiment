FROM ubuntu:16.04
MAINTAINER Mats Sjöberg <mats.sjoberg@helsinki.fi>

# Update OS and install requirements
RUN apt-get update && apt-get install --no-install-recommends openjdk-8-jre-headless -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get upgrade -y


# Set up environment, copy files
ENV DIME_DIR /srv/dime-server
ENV DIME_JAR ${DIME_DIR}/dime-server.jar

RUN mkdir -p ${DIME_DIR}
ADD build/libs/dime-server.jar ${DIME_JAR}

VOLUME ["/var/lib/dime"]
RUN ln -s /var/lib/dime ~/.dime

# Run on port 8080
EXPOSE 8080
CMD java -jar ${DIME_JAR}
