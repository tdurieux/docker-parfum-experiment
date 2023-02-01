# 
FROM muccg/python-base:2.7-debian-8
LABEL maintainer "https://github.com/muccg/"

ENV PROJECT_NAME yabi
ENV PROJECT_SOURCE https://github.com/muccg/yabi.git
ENV DEPLOYMENT prod
ENV PRODUCTION 1
ENV DEBUG 0
ENV STATIC_ROOT /data/static
ENV WRITABLE_DIRECTORY /data/scratch
ENV MEDIA_ROOT /data/static/media
ENV LOG_DIRECTORY /data/log
ENV DJANGO_SETTINGS_MODULE yabi.settings

# Project specific deps