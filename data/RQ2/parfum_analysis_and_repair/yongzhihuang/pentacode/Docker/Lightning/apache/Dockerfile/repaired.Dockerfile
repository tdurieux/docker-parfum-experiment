FROM ubuntu:14.04
MAINTAINER PentaCode
RUN apt-get install --no-install-recommends -y apache2 && rm -rf /var/lib/apt/lists/*;
EXPOSE 80
CMD ["apache2ctl", "-D", "FOREGROUND"]]
