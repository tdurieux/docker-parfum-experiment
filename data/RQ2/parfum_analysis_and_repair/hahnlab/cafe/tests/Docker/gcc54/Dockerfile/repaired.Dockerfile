# Set the base image
FROM gcc:5.4

# Dockerfile author / maintainer
MAINTAINER Name befulton@iu.edu

RUN apt-get update && apt-get -y upgrade && apt-get -y --no-install-recommends install git automake cpputest && rm -rf /var/lib/apt/lists/*;

COPY cafe_test.sh .

