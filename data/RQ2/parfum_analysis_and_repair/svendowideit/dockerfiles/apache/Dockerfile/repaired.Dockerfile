FROM debian:stable
MAINTAINER	Sven Dowideit <SvenDowideit@home.org.au>

RUN apt-get update && apt-get install --no-install-recommends -y --force-yes apache2 && rm -rf /var/lib/apt/lists/*;
EXPOSE 80 443
CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]

