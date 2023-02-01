# Docker file for JuliaBox Engine providing REST APIs
# Version:1

FROM juliabox/enginebase

MAINTAINER Tanmay Mohapatra

# Expose the HTTP port
# For proxying to work efficiently, it may be best to run the container on host network stack
EXPOSE 8887

USER juser
ENV LANG en_US.utf8

ENTRYPOINT ["/jboxengine/src/jbapi.py"]