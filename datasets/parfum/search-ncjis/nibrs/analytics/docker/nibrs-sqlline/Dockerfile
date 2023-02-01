FROM openjdk:8-alpine

RUN mkdir -p /opt && cd /opt && \
  apk --update add curl bash && \
  curl -O https://www-us.apache.org/dist/drill/drill-1.15.0/apache-drill-1.15.0.tar.gz && \
  tar -xvf apache-drill-1.15.0.tar.gz

RUN sed -i s/localhost/ec2-3-83-39-236.compute-1.amazonaws.com/g /opt/apache-drill-1.15.0/conf/drill-override.conf && \
  sed -i "s/ref=\"FILE\"/ref=\"STDOUT\"/g" /opt/apache-drill-1.15.0/conf/logback.xml

ENV PATH="$PATH:/opt/apache-drill-1.15.0/bin"

CMD sqlline
