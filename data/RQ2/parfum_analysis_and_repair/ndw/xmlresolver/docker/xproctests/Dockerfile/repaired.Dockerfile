# Created by Norm Walsh for running the XProc test suite http tests.
# Note: if you change the version of httpd in this container, you
# may also need to change the configuration and other setup files
# mounted in the container (see ../docker-compose.yml)
FROM httpd:2.4

RUN apt-get update -y
RUN apt-get install --no-install-recommends -y apt-utils locales curl procps && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libcgi-pm-perl && rm -rf /var/lib/apt/lists/*;

RUN mkdir /src

CMD ["httpd-foreground"]
