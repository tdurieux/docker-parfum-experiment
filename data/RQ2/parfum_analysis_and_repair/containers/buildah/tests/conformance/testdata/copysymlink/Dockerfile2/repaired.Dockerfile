FROM registry.centos.org/centos/centos:centos7
COPY file.tar.gz /
RUN ln -s file.tar.gz file-link.tar.gz
RUN ls -l /file-link.tar.gz
FROM registry.centos.org/centos/centos:centos7
COPY --from=0 /file-link.tar.gz /
RUN ls -l /file-link.tar.gz