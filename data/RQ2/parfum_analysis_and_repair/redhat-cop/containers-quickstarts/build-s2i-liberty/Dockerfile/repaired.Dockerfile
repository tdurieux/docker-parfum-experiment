# This image provides a base for building and running WildFly applications.
# It builds using maven and runs the resulting artifacts on WildFly 10.1.0 Final

FROM websphere-liberty:webProfile8

MAINTAINER Raffaele Spazzoli <rspazzol@redhat.com>

LABEL io.openshift.s2i.scripts-url=image:///usr/local/s2i \
      io.s2i.scripts-url=image:///usr/local/s2i \
      io.k8s.description="Platform for building and running JEE applications on IBM WebSphere Liberty Profile" \
      io.k8s.display-name="Liberty 18.0.0.3 webProfile8" \
      io.openshift.expose-services="9080/tcp:http, 9443/tcp:https" \
      io.openshift.tags="runner, builder,liberty" \
      io.openshift.s2i.destination="/tmp"

ENV STI_SCRIPTS_PATH="/usr/local/s2i" \ 
    WORKDIR="/usr/local/workdir" \
    WLP_DEBUG_ADDRESS="7777" \
    ENABLE_DEBUG="false" \ 
    ENABLE_JOLOKIA="true" \
    S2I_DESTINATION="/tmp" 

# Copy the S2I scripts from the specific language image to $STI_SCRIPTS_PATH