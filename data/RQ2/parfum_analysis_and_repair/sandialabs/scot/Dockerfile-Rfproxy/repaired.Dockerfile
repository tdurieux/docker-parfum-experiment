FROM sandialabs/scot_perl 

#Create log directory
RUN mkdir -p /var/log/scot
RUN mkdir -p /opt/scot

COPY install/src/scot/ /opt/scot/etc/
COPY bin/rfproxy.pl /opt/scot/bin/

CMD ["/usr/bin/perl", "/opt/scot/bin/rfproxy.pl"]