#
# iRODS Provider Image.
#
FROM ubuntu:16.04

# TODO: Remove this line when apt gets its stuff together
RUN sed --in-place --regexp-extended "s/(\/\/)(archive\.ubuntu)/\1nl.\2/" /etc/apt/sources.list

# Install pre-requisites
RUN apt-get update && \
    apt-get install --no-install-recommends -y sudo wget lsb-release apt-transport-https postgresql vim python-pip libfuse2 unixodbc rsyslog less nano libjson-perl python-psutil python-requests lsof python-jsonschema odbc-postgresql super && \
    pip install --no-cache-dir xmlrunner && rm -rf /var/lib/apt/lists/*;


# Grab .debs
RUN wget --no-check-certificate https://files.renci.org/pub/irods/releases/4.1.12/ubuntu14/irods-runtime-4.1.12-ubuntu14-x86_64.deb && \
    wget --no-check-certificate https://files.renci.org/pub/irods/releases/4.1.12/ubuntu14/irods-icat-4.1.12-ubuntu14-x86_64.deb && \
    wget --no-check-certificate https://files.renci.org/pub/irods/releases/4.1.12/ubuntu14/irods-database-plugin-postgres-1.12-ubuntu14-x86_64.deb

RUN dpkg -i irods-runtime-4.1.12-ubuntu14-x86_64.deb
RUN dpkg -i irods-icat-4.1.12-ubuntu14-x86_64.deb
RUN dpkg -i irods-database-plugin-postgres-1.12-ubuntu14-x86_64.deb

# Setup catalog database
ADD db_commands.txt /
ADD testsetup-consortium.sh /
RUN service postgresql start && su - postgres -c 'psql -f /db_commands.txt'

# Set command to execute when launching the container.
ADD start_provider.sh /
RUN chmod u+x /start_provider.sh
ENTRYPOINT ["./start_provider.sh"]
