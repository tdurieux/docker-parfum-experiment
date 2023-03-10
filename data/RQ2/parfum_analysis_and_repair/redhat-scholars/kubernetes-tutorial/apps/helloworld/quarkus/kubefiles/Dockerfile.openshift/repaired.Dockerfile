FROM registry.access.redhat.com/ubi8/ubi-minimal
WORKDIR /work/
RUN chgrp -R 0 /work && \ 
    chmod -R g=u /work
COPY target/*-runner /work/application
EXPOSE 8080
USER 1001
ENTRYPOINT [ "./application", "-Xmx8m", "-Xmn8m", "-Xms8m" ]