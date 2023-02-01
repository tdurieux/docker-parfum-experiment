FROM centos:centos7

# Install huge list of dependencies
RUN rm -rf /var/cache/yum/x86_64/latest
RUN yum update -y
RUN yum install sudo -y && rm -rf /var/cache/yum
RUN yum install python -y && rm -rf /var/cache/yum
RUN yum install https://centos7.iuscommunity.org/ius-release.rpm -y && rm -rf /var/cache/yum
RUN yum install python36u -y && rm -rf /var/cache/yum
RUN yum install python36u-pip -y && rm -rf /var/cache/yum
RUN yum install python36u-devel -y && rm -rf /var/cache/yum
RUN pip3.6 install awscli
RUN yum install zip -y && rm -rf /var/cache/yum
RUN yum install unzip -y && rm -rf /var/cache/yum
RUN yum -y install findutils && rm -rf /var/cache/yum
RUN yum -y install rpm && rm -rf /var/cache/yum
RUN yum -y install wget && rm -rf /var/cache/yum
RUN yum -y install Xvfb && rm -rf /var/cache/yum
RUN yum -y install binutils && rm -rf /var/cache/yum
RUN yum -y install gawk && rm -rf /var/cache/yum
RUN yum -y install coreutils && rm -rf /var/cache/yum
RUN yum -y install sed && rm -rf /var/cache/yum
RUN yum -y install redhat-lsb-core && rm -rf /var/cache/yum

RUN wget https://dl.google.com/linux/linux_signing_key.pub
RUN rpm --import linux_signing_key.pub
RUN yum -y localinstall https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm
RUN ls /usr/bin/google-chrome

RUN curl -f https://intoli.com/install-google-chrome.sh | bash
RUN sudo /usr/bin/pip3.6 install pyvirtualdisplay

ADD launch.sh /usr/local/bin/launch.sh
WORKDIR /tmp
USER root

ENTRYPOINT ["/usr/local/bin/launch.sh"]