# Docker image for testing basic spinup
# of multiple containers running a basic
# service, in this case Apache

FROM centos:centos6
MAINTAINER Chris Collins <collins.christopher@gmail.com>

RUN yum install -y httpd mod_php && rm -rf /var/cache/yum
RUN echo '<?php print "Hello World!" ?>' > /var/www/html/index.php

EXPOSE 80

ENTRYPOINT ["/usr/sbin/httpd"]
CMD ["-D", "FOREGROUND"]
