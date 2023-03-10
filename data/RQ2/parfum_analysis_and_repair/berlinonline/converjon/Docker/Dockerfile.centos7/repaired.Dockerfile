################################################################################
# Base image
################################################################################

FROM centos/nodejs-6-centos7

################################################################################
# Build instructions
################################################################################
USER root
RUN yum install -y \
    ImageMagick \
    perl-App-cpanminus && rm -rf /var/cache/yum

RUN cpanm Image::ExifTool
COPY start.sh /start.sh
RUN chmod 755 /start.sh
USER default
RUN scl enable rh-nodejs6 "npm install converjon"
EXPOSE 8000
ENV USE_CONFIG_DIR=false

CMD ["/bin/bash", "/start.sh"]
