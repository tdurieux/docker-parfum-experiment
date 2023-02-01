FROM ubuntu:16.04
RUN apt-get -y update && apt-get -y --no-install-recommends install openjdk-8-jdk unzip supervisor wget && rm -rf /var/lib/apt/lists/*;
RUN printf '[supervisord]\nnodaemon=true\n\n[program:nginx-admin]\ncommand = /opt/nginx-admin-2.0.3/scripts/debian/nginx-admin.sh start\n' >> /etc/supervisord.conf
RUN useradd nginx-admin -r
RUN mkdir -p /opt/downloads
RUN wget https://github.com/jslsolucoes/nginx-admin/raw/master/nginx-admin-bin/nginx-admin-2.0.3.zip -O /opt/downloads/nginx-admin-2.0.3.zip
RUN unzip /opt/downloads/nginx-admin-2.0.3.zip -d /opt
RUN chmod -R 755 /opt/nginx-admin-2.0.3
RUN chown -R nginx-admin:nginx-admin /opt/nginx-admin-2.0.3
ENV NGINX_ADMIN_HOME /opt/nginx-admin-2.0.3
EXPOSE 4000
EXPOSE 4443
CMD ["/usr/bin/supervisord"]