FROM centos:8
ENV SHELL bash
RUN yum install -y vim man && rm -rf /var/cache/yum
RUN yum install -y git python3-docutils rpm-build wget make && rm -rf /var/cache/yum
RUN wget https://storage.googleapis.com/golang/getgo/installer_linux
RUN chmod +x installer_linux
RUN bash -c "./installer_linux"
RUN bash -c "source /root/.bash_profile"

ADD . /skogul
