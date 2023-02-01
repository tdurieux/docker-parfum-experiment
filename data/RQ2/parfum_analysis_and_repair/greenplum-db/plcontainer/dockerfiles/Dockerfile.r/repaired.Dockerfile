FROM centos:7

EXPOSE 8080

RUN mkdir -p /clientdir
RUN yum install -y epel-release && rm -rf /var/cache/yum
RUN yum install -y R && rm -rf /var/cache/yum

ENV R_HOME "/usr/lib64/R"
ENV PATH "/usr/lib64/R/bin:$PATH"
ENV LD_LIBRARY_PATH "/usr/lib64/R/lib:$LD_LIBRARY_PATH"

WORKDIR /clientdir
