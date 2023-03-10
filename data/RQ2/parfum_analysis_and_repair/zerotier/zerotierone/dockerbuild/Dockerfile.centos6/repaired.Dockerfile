FROM centos:6

ARG go_pkg_url

RUN yum update -y
RUN yum install -y curl git wget openssh-server sudo make rpmdevtools && yum clean all && rm -rf /var/cache/yum

RUN curl -f -s $go_pkg_url -o go.tar.gz && \
    tar -C /usr/local -xzf go.tar.gz && \
   rm go.tar.gz

RUN groupadd -g 1000 jenkins-build && useradd -u 1000 -g 1000 jenkins-build

RUN echo $'\n\
  export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin\n'\
  >> ~/.bash_profile

RUN mkdir /rpmbuild && chmod 777 /rpmbuild

CMD ["/usr/sbin/sshd", "-D"]
