# Python 3.8.12:buster
FROM gwul/sfm-base@sha256:0b80a3d3562cdb4d631fbb55b9bd24889312838cbd27cd33e14cc0c18405f007
MAINTAINER Social Feed Manager <sfm@gwu.edu>

ADD . /opt/sfm-ui/
WORKDIR /opt/sfm-ui
RUN pip install --no-cache-dir -r requirements/common.txt -r

ADD docker/consumer/invoke_consumer.sh /opt/sfm-setup/
RUN chmod +x /opt/sfm-setup/invoke_consumer.sh

ENV DJANGO_SETTINGS_MODULE=sfm.settings.docker_settings
ENV LOAD_FIXTURES=false

CMD ["/opt/sfm-setup/invoke_consumer.sh"]
