FROM open-liberty:kernel-ubi-min

RUN cp /opt/ol/wlp/templates/servers/webProfile7/server.xml /config/server.xml
