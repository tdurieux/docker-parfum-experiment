##pmacct (Promiscuous mode IP Accounting package)
##pmacct is Copyright (C) 2003-2020 by Paolo Lucente

#Author: Marc Sune <marcdevel (at) gmail.com>

#This Dockerfile creates an image for pmtelemetryd 

FROM base:_build
MAINTAINER pmacct Docker Doctors <docker-doctors (at) pmacct.net>

ENTRYPOINT ["/usr/local/sbin/pmtelemetryd"]
CMD ["-f", "/etc/pmacct/pmtelemetryd.conf"]
