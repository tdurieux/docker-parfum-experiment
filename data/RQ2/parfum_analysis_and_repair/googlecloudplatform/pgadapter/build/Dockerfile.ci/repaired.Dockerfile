FROM ubuntu:18.04

ARG UBER_JAR_PATH
RUN apt-get update && apt-get -qq --no-install-recommends -y install default-jre && rm -rf /var/lib/apt/lists/*;

COPY ${UBER_JAR_PATH} /home/pgadapter/pgadapter.jar
COPY LICENSE /home/pgadapter/
COPY CONTRIBUTING.md /home/pgadapter/
COPY README.md /home/pgadapter/
COPY logging.properties /home/pgadapter/

# Add startup script.
ADD build/startup.sh /home/pgadapter/startup.sh
RUN chmod +x /home/pgadapter/startup.sh

ENTRYPOINT ["/bin/bash", "/home/pgadapter/startup.sh"]
