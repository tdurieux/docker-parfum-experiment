FROM centos:8

ARG go_pkg_url

RUN yum install -y epel-release && rm -rf /var/cache/yum
RUN yum install -y curl git wget openssh-server sudo make rpmdevtools clang gcc-c++ ruby ruby-devel && yum clean all && rm -rf /var/cache/yum

RUN curl -f -s $go_pkg_url -o go.tar.gz && \
    tar -C /usr/local -xzf go.tar.gz && \
    rm go.tar.gz

RUN wget -qO- "https://cmake.org/files/v3.15/cmake-3.15.1-Linux-x86_64.tar.gz" | tar --strip-components=1 -xz -C /usr/local

RUN /usr/bin/ssh-keygen -A
RUN useradd jenkins-build

RUN echo $'\n\
  export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin\n\
  source scl_source enable devtoolset-8 llvm-toolset-7\n'\
  >> ~/.bash_profile

RUN mkdir /rpmbuild && chmod 777 /rpmbuild

CMD ["/usr/sbin/sshd", "-D"]

