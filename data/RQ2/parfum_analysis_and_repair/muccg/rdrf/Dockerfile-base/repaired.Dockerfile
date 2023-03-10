FROM muccg/python-base:3.8-debian-10
MAINTAINER https://github.com/muccg/rdrf/

ENV PROJECT_NAME rdrf
ENV PROJECT_SOURCE https://github.com/muccg/rdrf.git
ENV DEPLOYMENT prod
ENV PRODUCTION 1
ENV DEBUG 0
ENV STATIC_ROOT /data/static
ENV WRITABLE_DIRECTORY /data/scratch
ENV MEDIA_ROOT /data/static/media
ENV LOG_DIRECTORY /data/log
ENV LOCALE_PATHS /data/translations/locale
ENV DJANGO_SETTINGS_MODULE rdrf.settings

RUN env | sort

# Project specific deps
RUN apt-get update && apt-get install -y --no-install-recommends \
  gettext \
  libpcre3 \
  libpq5 \
  mime-support \
  libnode64 \
  nodejs \
  unixodbc \
  python-ldap \
  libsasl2-dev \
  python-dev \
  libldap2-dev \
  libssl-dev \
  nfs-common \
  && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

#RUN pip install --upgrade pip
RUN pip install --no-cache-dir zipp
RUN pip install --no-cache-dir --upgrade "setuptools==60.9.3"


ENTRYPOINT ["/bin/sh"]
