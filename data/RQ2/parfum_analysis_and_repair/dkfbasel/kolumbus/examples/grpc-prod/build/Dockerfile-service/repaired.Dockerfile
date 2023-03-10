# USE ALPINE LINUX AS BASE IMAGE (TO ALLOW BASH NAVIGATION)
FROM envoyproxy/envoy-alpine:0f88bc5113d4cce320045c3cd11d626af69bd775

MAINTAINER DKF-Basel <info@dkfbasel.ch>
LABEL copyright="Departement Klinische Forschung, Basel, Switzerland. 2017"

# COPY THE APPLICATIN FILES INTO THE CONTAINER
RUN mkdir /app
ADD bin/service /app/bin/service

# ADD STARTUP SCRIPTS
ADD scripts/service.sh /app/scripts/service.sh

# ADD ENVOY CONFIGURATION
ADD envoy/service.json /app/envoy/service.json

# CREATE A DIRECTORY FOR ENVOY LOGS
RUN mkdir /var/log/envoy/

# SET THE CURRENT WORKING DIRECTORY
WORKDIR /app

# START THE APPLICATION WITH THE CONTAINER