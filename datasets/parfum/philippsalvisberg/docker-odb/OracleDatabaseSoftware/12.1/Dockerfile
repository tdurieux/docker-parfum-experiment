FROM oraclelinux:7.6

LABEL maintainer="philipp.salvisberg@gmail.com"
LABEL description="Oracle Database Enterprise Edition 12.1 software only"
LABEL build.command="docker build . --tag phsalvisberg/odb:12.1sw"

# copy all scripts
ADD assets /assets/

# image setup via shell script to reduce layers and optimize final disk usage
RUN /assets/db_setup.sh
