FROM phsalvisberg/odb:11.2sw

LABEL maintainer="philipp.salvisberg@gmail.com"
LABEL description="Oracle Database Enterprise Edition 11.2"
LABEL build.command="docker build . --tag phsalvisberg/odb:11.2"
LABEL run.command="docker run -v odb:/u02 -it -p 1158:1158 -p 8081:8081 -p 1521:1521 -h odb --name odb phsalvisberg/odb:11.2"

# environment variables (defaults for DBCA and entrypoint.sh)
ENV DBCONTROL=true \
    APEX=true \
    ORDS=true \
    DBCA_TOTAL_MEMORY=2048 \
    GDBNAME=odb.docker \
    ORACLE_SID=odb \
    SERVICE_NAME=odb.docker \
    PASS=oracle \
    APEX_PASS=Oracle12c!

# copy all scripts
ADD assets /assets/

# image setup via shell script to reduce layers and optimize final disk usage
RUN /assets/image_setup.sh

# database port, Enterprise Manager Database Control port, ORDS port
EXPOSE 1521 1158 8081

# all data directories in /u01 are linked to this volume
VOLUME ["/u02"]

# entrypoint for database creation, startup and graceful shutdown
ENTRYPOINT ["/assets/entrypoint.sh"]
CMD [""]