#
# iRODS Consumer Image.
#
FROM ubuntu:16.04

# TODO: Remove this line when apt gets its stuff together
RUN sed --in-place --regexp-extended "s/(\/\/)(archive\.ubuntu)/\1nl.\2/" /etc/apt/sources.list

RUN apt-get update && \
    apt-get install --no-install-recommends -y sudo wget less lsb-release apt-transport-https netcat && rm -rf /var/lib/apt/lists/*;

RUN wget -qO - https://packages.irods.org/irods-signing-key.asc | apt-key add -; \
    echo "deb [arch=amd64] https://packages.irods.org/apt/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/renci-irods.list; \
    apt-get update && \
    apt-get install --no-install-recommends -y irods-runtime irods-icommands irods-server && rm -rf /var/lib/apt/lists/*;

EXPOSE 1247 1248

# Set command to execute when launching the container.
ADD start_consumer.sh irods_consumer.input /
RUN chmod u+x /start_consumer.sh
ENTRYPOINT ["./start_consumer.sh"]