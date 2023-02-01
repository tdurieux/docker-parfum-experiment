FROM debian:testing
MAINTAINER Tamás Gulácsi <tgulacsi78@gmail.com>

ENV DEBIAN_FRONTEND=noninteractive
RUN echo 'deb http://httpredir.debian.org/debian testing main contrib non-free' >/etc/apt/sources.list
RUN apt-get -y update && apt-get -y upgrade
RUN apt-get -y --no-install-recommends install fonts-sil-gentium fonts-dejavu-extra fonts-liberation fonts-takao-mincho ttf-mscorefonts-installer && rm -rf /var/lib/apt/lists/*;
# https://stackoverflow.com/questions/25193161/chfn-pam-system-error-intermittently-in-docker-hub-builds
RUN ln -sf /bin/true /usr/bin/chfn

RUN apt-get -y --no-install-recommends install \
	ghostscript graphicsmagick pdftk poppler-utils mupdf-tools \
	libemail-outlook-message-perl && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install libreoffice && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install wkhtmltopdf && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install procps && rm -rf /var/lib/apt/lists/*;

#RUN addgroup --quiet --gid 10507 agostle
#RUN adduser --quiet --gecos 'agostle' --disabled-password --uid 10507 --gid 10507 agostle

#USER agostle
#WORKDIR /home/agostle

WORKDIR /app
EXPOSE 9500:9500
VOLUME ["/app/bin"]
ENTRYPOINT ["/bin/dash", "-c"]
CMD ["/app/bin/agostle serve 0.0.0.0:9500"]
