#
# iRODS Provider Image.
#
FROM ubuntu:16.04

# TODO: Remove this line when apt gets its stuff together
RUN sed --in-place --regexp-extended "s/(\/\/)(archive\.ubuntu)/\1nl.\2/" /etc/apt/sources.list

# Install pre-requisites
RUN apt-get update && \
    apt-get install --no-install-recommends -y sudo wget lsb-release apt-transport-https postgresql vim python-pip libfuse2 unixodbc rsyslog less && \
    pip install --no-cache-dir xmlrunner && rm -rf /var/lib/apt/lists/*;

# Setup catalog database
ADD db_commands.txt /
RUN service postgresql start && su - postgres -c 'psql -f /db_commands.txt'

RUN wget -qO - https://packages.irods.org/irods-signing-key.asc | apt-key add -; \
    echo "deb [arch=amd64] https://packages.irods.org/apt/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/renci-irods.list; \
    apt-get update && \
    apt-get install --no-install-recommends -y irods-runtime irods-icommands irods-server irods-database-plugin-postgres && rm -rf /var/lib/apt/lists/*;

EXPOSE 1247 1248

ADD for-etc-irods /

# Set command to execute when launching the container.
ADD start_provider.sh /
ADD testsetup-consortium.sh /
RUN chmod +x /testsetup-consortium.sh
RUN chmod u+x /start_provider.sh
ENTRYPOINT ["./start_provider.sh"]


