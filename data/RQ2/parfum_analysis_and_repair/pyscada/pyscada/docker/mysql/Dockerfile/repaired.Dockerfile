## Pull the mysql:5.6 image
FROM mysql:latest

## The maintainer name and email
LABEL maintainer="PyScada | Martin Schröder <info@martin-schroeder.net"

# Install requirement (wget)
#RUN apt-get update && apt-get install -y wget