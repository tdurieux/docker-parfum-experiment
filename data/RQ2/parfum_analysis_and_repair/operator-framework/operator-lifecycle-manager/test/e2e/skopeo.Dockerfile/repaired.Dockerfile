FROM fedora:31
RUN yum install -y skopeo && rm -rf /var/cache/yum

ENTRYPOINT ["skopeo"]