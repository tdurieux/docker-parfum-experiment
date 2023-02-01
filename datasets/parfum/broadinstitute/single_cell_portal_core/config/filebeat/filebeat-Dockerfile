FROM docker.elastic.co/beats/filebeat:5.6.14
USER root
RUN mkdir /var/log/rails
RUN chown root:filebeat -R /var/log/rails
COPY config/filebeat/filebeat.yml /usr/share/filebeat/filebeat.yml
RUN chown root:filebeat /usr/share/filebeat/filebeat.yml
RUN mkdir /usr/share/filebeat/conf.d
COPY config/filebeat/nginx.yml config/filebeat/rails.yml /usr/share/filebeat/conf.d/
RUN chown root:filebeat -R /usr/share/filebeat/conf.d
RUN usermod -o -u 1004 filebeat
USER filebeat