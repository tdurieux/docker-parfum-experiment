FROM {{ "maven-java8" | image_tag }}

USER root
RUN {{ "gearman-job-server" | apt_install }}

COPY run-with-gearmand.sh /run-with-gearmand.sh
USER nobody
ENTRYPOINT ["/run-with-gearmand.sh"]