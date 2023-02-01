FROM jasonrivers/nagios

RUN apt-get update && apt-get install --no-install-recommends -y \
    libcurl4-openssl-dev \
    libjansson-dev && rm -rf /var/lib/apt/lists/*;

RUN echo "broker_module=/opt/nagios/libexec/alerta-neb.o http://alerta:8080/api key=demo-admin-key debug=1" >>/opt/nagios/etc/nagios.cfg

COPY alerta-neb.o /opt/nagios/libexec/alerta-neb.o

