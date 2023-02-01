FROM openjdk:8-alpine

# to run standalone/embedded:
#
#    docker run -it --rm searchncjis/nibrs-drill drill-embedded
#
# to run as a detached service, you have to run it as a zookeeper node.  use the nibrs-analytics-drill-compose.yaml docker-compose file.
#
# If you are running the detached service, you can run an interactive container like this to get a sqlline query prompt (note: the network name here is the one resulting from upping the docker-compose file):
#
#    docker run -it --rm --network docker_nibrs_analytics_nw searchncjis/nibrs-drill drill-conf

RUN mkdir -p /opt && cd /opt && \
  apk --update add curl bash && \
  curl -O https://downloads.apache.org/drill/drill-1.18.0/apache-drill-1.18.0.tar.gz   && \
  tar -xvf  apache-drill-1.18.0.tar.gz  

RUN sed -i s/localhost/zoo/g /opt/apache-drill-1.18.0/conf/drill-override.conf && \
  sed -i "s/ref=\"FILE\"/ref=\"STDOUT\"/g" /opt/apache-drill-1.18.0/conf/logback.xml

ENV PATH="$PATH:/opt/apache-drill-1.18.0/bin"

COPY files/storage-plugins-override.conf /opt/apache-drill-1.18.0/conf/

CMD drillbit.sh run
