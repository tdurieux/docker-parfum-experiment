FROM s390x/clefos:7

ARG go_pkg_url

RUN yum install -y curl git wget openssh-server sudo make development-tools rpmdevtools clang gcc-c++ ruby ruby-devel && yum clean all && rm -rf /var/cache/yum

RUN curl -f -s $go_pkg_url -o go.tar.gz && \
    tar -C /usr/local -xzf go.tar.gz && \
    rm go.tar.gz

RUN /usr/bin/ssh-keygen -A

RUN echo $'\n\
  export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin\n'\
  >> ~/.bash_profile

RUN mkdir /rpmbuild && chmod 777 /rpmbuild

CMD ["/usr/sbin/sshd", "-D"]

